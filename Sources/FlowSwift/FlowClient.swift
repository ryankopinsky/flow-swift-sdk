//
//  FlowClient.swift
//  
//
//  Created by Ryan Kopinsky on 9/8/21.
//

import Foundation
import GRPC
import Flow
import NIO
import SwiftProtobuf

public struct FlowClient {
    private let client: Flow_Access_AccessAPIClient
    private(set) var channel: GRPCChannel
    
    public init(host: String, port: Int) {
        // Make EventLoopGroup for the specific platform
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
//        defer {
//            try? group.syncShutdownGracefully()
//        }
        
        self.channel = ClientConnection.insecure(group: group)
            .connect(host: host, port: port)
        
        self.client = Flow_Access_AccessAPIClient(channel: channel)
        
//        defer {
//            try? channel.close().wait()
//        }
    }
    
    public func ping(completion: @escaping(_ error: Error?) -> Void) {
        let request = Flow_Access_PingRequest()
        let response = self.client.ping(request).response
        
        response.whenSuccess { pingResponse in
//            print("Ping Success: \(pingResponse.debugDescription)")
            completion(nil)
        }
        
        response.whenFailure { error in
//            print("Ping Error: \(error.localizedDescription)")
            completion(error)
        }
        
        response.whenComplete { _ in
//            print("Finished ping().")
        }
    }
    
    // MARK: - Accounts
    
    enum FlowAccountError: Error {
        case unableToDecodeAddress
    }
    
    public func getAccount(address: String, completion: @escaping(_ account: Flow_Entities_Account?, _ error: Error?) -> Void) {
        guard let addressData = address.data(using: .hexadecimal) else {
            print("Unable to encode \(address). Verify that address is a hexadecimal string.")
            completion(nil, FlowAccountError.unableToDecodeAddress)
            return
        }
                
        do {
            let requestData = try Flow_Access_GetAccountAtLatestBlockRequest.with {
                $0.address = addressData
            }.serializedData()
            let request = try Flow_Access_GetAccountAtLatestBlockRequest(serializedData: requestData)
            let response = client.getAccountAtLatestBlock(request).response
            
            response.whenSuccess { accountResponse in
                completion(accountResponse.account, nil)
            }
            
            response.whenFailure { error in
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    // MARK: - Scripts

    public func executeScript(script: Data, arguments: [Data], completion: @escaping(_ responseValue: [String : Any]?, _ error: Error?) -> Void) {
        do {
            let requestData = try Flow_Access_ExecuteScriptAtLatestBlockRequest.with {
                $0.script = script
                $0.arguments = arguments
            }.serializedData()
            
            let request = try Flow_Access_ExecuteScriptAtLatestBlockRequest(serializedData: requestData)
            
            let response = client.executeScriptAtLatestBlock(request).response
            
            response.whenSuccess { executeScriptResponse in
                let json = try! JSONSerialization.jsonObject(with: executeScriptResponse.value, options: []) as? [String : Any]

                completion(json, nil)
            }
            
            response.whenFailure { error in
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
}


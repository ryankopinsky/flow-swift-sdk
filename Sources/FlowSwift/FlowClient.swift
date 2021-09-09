//
//  FlowClient.swift
//  
//
//  Created by Ryan Kopinsky on 9/8/21.
//

import Foundation
import GRPC
import Flow

public struct FlowClient {
    private(set) var client: Flow_Access_AccessAPIClient
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
}


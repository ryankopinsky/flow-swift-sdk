//
//  File.swift
//  
//
//  Created by Ryan Kopinsky on 9/9/21.
//

import Foundation
import Flow

extension FlowClient {
    
    // Flow Access API: https://docs.onflow.org/access-api/#executescriptatlatestblock
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
    
    // Flow Access API: https://docs.onflow.org/access-api/#executescriptatblockheight
    public func executeScript(script: Data, arguments: [Data], blockHeight: UInt64, completion: @escaping(_ responseValue: [String : Any]?, _ error: Error?) -> Void) {
        do {
            let requestData = try Flow_Access_ExecuteScriptAtBlockHeightRequest.with {
                $0.script = script
                $0.arguments = arguments
                $0.blockHeight = blockHeight
            }.serializedData()
            
            let request = try Flow_Access_ExecuteScriptAtBlockHeightRequest(serializedData: requestData)
            
            let response = client.executeScriptAtBlockHeight(request).response
            
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

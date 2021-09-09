//
//  FlowClient+Blocks.swift
//  
//
//  Created by Ryan Kopinsky on 9/9/21.
//

import Foundation
import Flow

extension FlowClient {
    
    // Flow Access API: https://docs.onflow.org/access-api/#getlatestblock
    public func getLatestBlock(isSealed: Bool, completion: @escaping(_ block: Flow_Entities_Block?, _ error: Error?) -> Void) {
        do {
            let requestData = try Flow_Access_GetLatestBlockRequest.with {
                $0.isSealed = isSealed
            }.serializedData()
            
            let request = try Flow_Access_GetLatestBlockRequest(serializedData: requestData)
            
            let response = client.getLatestBlock(request).response
            
            response.whenSuccess { blockResponse in
                completion(blockResponse.block, nil)
            }
            
            response.whenFailure { error in
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    // Flow Access API: https://docs.onflow.org/access-api/#getblockbyheight
    public func getBlock(height: UInt64, completion: @escaping(_ block: Flow_Entities_Block?, _ error: Error?) -> Void) {
        do {
            let requestData = try Flow_Access_GetBlockByHeightRequest.with {
                $0.height = height
            }.serializedData()
            
            let request = try Flow_Access_GetBlockByHeightRequest(serializedData: requestData)
            
            let response = client.getBlockByHeight(request).response
            
            response.whenSuccess { blockResponse in
                completion(blockResponse.block, nil)
            }
            
            response.whenFailure { error in
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
}

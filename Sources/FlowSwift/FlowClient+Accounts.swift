//
//  FlowClient+Accounts.swift
//  
//
//  Created by Ryan Kopinsky on 9/9/21.
//

import Foundation
import Flow

extension FlowClient {
    enum FlowAccountError: Error {
        case unableToDecodeAddress
    }
    
    // Flow Access API: https://docs.onflow.org/access-api/#getaccountatlatestblock
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
    
    // Flow Access API: https://docs.onflow.org/access-api/#getaccountatblockheight
    public func getAccount(address: String, blockHeight: UInt64, completion: @escaping(_ account: Flow_Entities_Account?, _ error: Error?) -> Void) {
        guard let addressData = address.data(using: .hexadecimal) else {
            print("Unable to encode \(address). Verify that address is a hexadecimal string.")
            completion(nil, FlowAccountError.unableToDecodeAddress)
            return
        }
        
        do {
            let requestData = try Flow_Access_GetAccountAtBlockHeightRequest.with {
                $0.address = addressData
                $0.blockHeight = blockHeight
            }.serializedData()
            let request = try Flow_Access_GetAccountAtBlockHeightRequest(serializedData: requestData)
            let response = client.getAccountAtBlockHeight(request).response
            
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
}

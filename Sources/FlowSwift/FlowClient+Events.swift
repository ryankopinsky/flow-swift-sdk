//
//  FlowClient+Events.swift
//  
//
//  Created by Ryan Kopinsky on 9/9/21.
//

import Foundation
import Flow

public enum FlowEventTypes: String {
    case Withdraw
    case Deposit
    case TokensWithdrawn
    case TokensDeposited
    case ForwardedDeposit
    case MomentListed
    case MomentPurchased
    case AccountCreated
    case AccountKeyAdded
}

extension FlowClient {
    // Flow Access API: https://docs.onflow.org/access-api/#geteventsforheightrange
    public func getEventsForHeightRange(type: String, startHeight: UInt64, endHeight: UInt64, completion: @escaping(_ eventsResponse: Flow_Access_EventsResponse?, _ error: Error?) -> Void) {
        do {
            let requestData = try Flow_Access_GetEventsForHeightRangeRequest.with {
                $0.type = type
                $0.startHeight = startHeight
                $0.endHeight = endHeight
            }.serializedData()
            
            let request = try Flow_Access_GetEventsForHeightRangeRequest(serializedData: requestData)
            
            let response = client.getEventsForHeightRange(request).response
            
            response.whenSuccess { eventsResponse in
                completion(eventsResponse, nil)
            }
            
            response.whenFailure { error in
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
}

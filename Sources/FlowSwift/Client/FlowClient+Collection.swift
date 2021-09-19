import Foundation

extension FlowClient {
    
    public func getCollectionById(id: FlowIdentifier, completion: @escaping(ResultCallback)){
        self.rpcProvider.getCollectionById(id: id, completion: completion)
    }

}

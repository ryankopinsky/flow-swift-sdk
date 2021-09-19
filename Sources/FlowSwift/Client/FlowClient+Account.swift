import Foundation

extension FlowClient {
    
    public func getAccount(account: FlowAddress, completion: @escaping(ResultCallback)){
        self.rpcProvider.getAccount(account: account, completion: completion)
    }
    
    public func getAccountAtLatestBlock(account: FlowAddress, completion: @escaping(ResultCallback)){
        self.rpcProvider.getAccountAtLatestBlock(account: account, completion: completion)
    }
    
    public func getAccountAtBlockHeight(account: FlowAddress, height: Int, completion: @escaping(ResultCallback)){
        self.rpcProvider.getAccountAtBlockHeight(account: account, height: height, completion: completion)
    }
    
}


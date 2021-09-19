import Foundation


extension FlowClient {

    public func executeScriptAtLatestBlock(_ script: String, arguments:[CadenceValue] = [], completion: @escaping(ResultCallback)){
        self.rpcProvider.executeScriptAtLatestBlock(script: script, arguments: arguments, completion: completion)
    }
    
    public func executeScriptAtBlockID(_ script: String, blockId: FlowIdentifier, arguments:[CadenceValue] = [], completion: @escaping(ResultCallback)){
        self.rpcProvider.executeScriptAtBlockId(script: script, blockId: blockId, arguments: arguments, completion: completion)
    }
    
    public func executeScriptAtBlockHeight(_ script: String, height: Int, arguments:[CadenceValue] = [], completion: @escaping(ResultCallback)){
        self.rpcProvider.executeScriptAtBlockHeight(script: script, height: height, arguments: arguments, completion: completion)

    }
    
}

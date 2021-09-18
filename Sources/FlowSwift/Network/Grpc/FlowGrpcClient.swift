import Foundation
import Flow

public class FlowGrpcClient: FlowRpcClientProtocol{
    
   
    
 
    
    
    var transport: GRPCTransport

    public init(host:String, port: Int){
        self.transport = GRPCTransport(host: host, port: port)
    }

    public func getTransactionResult(id: FlowIdentifier, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetTransactionRequest,Flow_Access_TransactionResultResponse>
            .with(self.transport.client.getTransactionResult,
            transform:{
                $0.id = Data(id)
            },success:{
                return FlowTransactionResult.from($0) as! FlowTransactionResult
            },
            completion: completion
        )
    }


    public func sendTransaction(transaction: FlowTransaction, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_SendTransactionRequest,Flow_Access_SendTransactionResponse>
            .with(self.transport.client.sendTransaction,
            transform:{
                var tosend = Flow_Entities_Transaction()
                tosend.script = transaction.script.data(using: .utf8)!
                tosend.arguments = transaction.arguments.map{arg in arg.toJSON()!}
                tosend.referenceBlockID = transaction.referenceBlockId.data
                tosend.gasLimit = UInt64(transaction.gasLimit)
                tosend.proposalKey.address = transaction.proposalKey.address.data
                tosend.proposalKey.keyID = UInt32(transaction.proposalKey.keyId)
                tosend.proposalKey.sequenceNumber = UInt64(transaction.proposalKey.sequenceNumber)
                tosend.payer = transaction.payer.data
                tosend.authorizers = transaction.authorizers.map{auth in auth.data}
                
                for signature in transaction.payloadSignatures{
                    var s = Flow_Entities_Transaction.Signature()
                    s.address = signature.address.data
                    s.keyID = UInt32(signature.keyId)
                    s.signature = signature.signature.data
                    tosend.payloadSignatures.append(s)
                }
                
                for signature in transaction.envelopeSignatures{
                    var s = Flow_Entities_Transaction.Signature()
                    s.address = signature.address.data
                    s.keyID = UInt32(signature.keyId)
                    s.signature = signature.signature.data
                    tosend.envelopeSignatures.append(s)
                }
                
                $0.transaction = tosend
                
                
            },
            success:{
                return FlowIdentifier.from($0.id)
            },
            completion: completion
        )
    }

    public func getAccount(account: FlowAddress, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetAccountRequest,Flow_Access_GetAccountResponse>
            .with(self.transport.client.getAccount,
            transform:{
                $0.address = account.data
            },
            success:{
                return FlowAccount.from($0.account) as? FlowAccount
            },
            completion: completion
        )
    }
    
    

    public func getAccountAtLatestBlock(account: FlowAddress, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetAccountAtLatestBlockRequest,Flow_Access_AccountResponse>
            .with(self.transport.client.getAccountAtLatestBlock,
            transform:{
                $0.address = account.data
            },
            success:{
                return FlowAccount.from($0.account) as? FlowAccount
            },
            completion: completion
        )
    }

    public func getAccountAtBlockHeight(account: FlowAddress, height: Int, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetAccountAtBlockHeightRequest,Flow_Access_AccountResponse>
            .with(self.transport.client.getAccountAtBlockHeight,
            transform:{
                $0.address = account.data
                $0.blockHeight = UInt64(height)
            },
            success:{
                return FlowAccount.from($0.account) as? FlowAccount
            },
            completion: completion
        )
    }

    public func ping(completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_PingRequest,Flow_Access_PingResponse>
            .with(self.transport.client.ping,
            transform:{_ in
            },
            success: {_ in
                return FlowEntity()
            },
            completion: completion
        )
    }

    public func getLatestBlock(isSealed: Bool, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetLatestBlockRequest,Flow_Access_BlockResponse>
            .with(self.transport.client.getLatestBlock,
            transform:{_ in
            },
            success:{
                return FlowBlock.from($0.block)
            },
            completion: completion
        )
    }

    public func getLatestBlockHeader(isSealed: Bool, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetLatestBlockHeaderRequest,Flow_Access_BlockHeaderResponse>
            .with(self.transport.client.getLatestBlockHeader,
            transform:{_ in
            },
            success:{
                return FlowBlockHeader.from($0.block)
            },
            completion: completion
        )
    }

    public func getBlockHeaderById(id: FlowIdentifier, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetBlockHeaderByIDRequest,Flow_Access_BlockHeaderResponse>
            .with(self.transport.client.getBlockHeaderByID,
            transform:{
                $0.id = Data(id)
            },
            success:{
                return FlowBlockHeader.from($0.block)
            },
            completion: completion
        )
    }

    public func getBlockHeaderByHeight(height: Int, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetBlockHeaderByHeightRequest,Flow_Access_BlockHeaderResponse>
            .with(self.transport.client.getBlockHeaderByHeight,
            transform:{
                $0.height = UInt64(height)
            },
            success:{
                return FlowBlockHeader.from($0.block)
            },
            completion: completion
        )
    }

    public func getBlockById(id: FlowIdentifier, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetBlockByIDRequest,Flow_Access_BlockResponse>
            .with(self.transport.client.getBlockByID,
            transform:{
                $0.id = Data(id)
            },
            success:{
                return FlowBlock.from($0.block)
            },
            completion: completion
        )
    }

    public func getBlockByHeight(height: Int, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetBlockByHeightRequest,Flow_Access_BlockResponse>
            .with(self.transport.client.getBlockByHeight,
            transform:{
                $0.height = UInt64(height)
            },
            success:{
                return FlowBlock.from($0.block)
            },
            completion: completion
        )
    }

    public func getExecutionResultForBlockId(id: FlowIdentifier, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetExecutionResultForBlockIDRequest,Flow_Access_ExecutionResultForBlockIDResponse>
            .with(self.transport.client.getExecutionResultForBlockID,
            transform:{
                $0.blockID = Data(id)
            },
            success:{
                return FlowExecutionResult.from($0.executionResult)
            },
            completion: completion
        )
    }

    public func getCollectionById(id: FlowIdentifier, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetCollectionByIDRequest,Flow_Access_CollectionResponse>
            .with(self.transport.client.getCollectionByID,
            transform:{
                $0.id = Data(id)
            },
            success:{
                return FlowCollection.from($0.collection)
            },
            completion: completion
        )
    }

    public func getEventsForHeightRange(type: String, start: Int, end: Int, completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetEventsForHeightRangeRequest,Flow_Access_EventsResponse>
            .with(self.transport.client.getEventsForHeightRange,
            transform:{
                $0.type = type
                $0.startHeight = UInt64(start)
                $0.endHeight = UInt64(end)
            },
            success:{
                return FlowEventsResponse.from($0)
            },
            completion: completion
        )
    }
   
    public func getEventsForBlockIds(type: String, blockIds: [FlowIdentifier], completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetEventsForBlockIDsRequest,Flow_Access_EventsResponse>
            .with(self.transport.client.getEventsForBlockIDs,
            transform:{
                $0.type = type
                $0.blockIds = blockIds.map{ Data($0) }
            },
            success:{
                return FlowEventsResponse.from($0)
            },
            completion: completion
        )
    }


    public func executeScriptAtLatestBlock(script: String, arguments: [CadenceValue], completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_ExecuteScriptAtLatestBlockRequest,Flow_Access_ExecuteScriptResponse>
            .with(self.transport.client.executeScriptAtLatestBlock,
            transform:{
                $0.script = script.data(using: .utf8)!
                $0.arguments = arguments.map{$0.toJSON()!}
            },
            success:{
                return CadenceValue.fromJSON($0.value)
            },
            completion: completion
        )
    }

    public func executeScriptAtBlockId(script: String, blockId: FlowIdentifier, arguments: [CadenceValue], completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_ExecuteScriptAtBlockIDRequest,Flow_Access_ExecuteScriptResponse>
            .with(self.transport.client.executeScriptAtBlockID,
            transform:{
                $0.script = script.data(using: .utf8)!
                $0.arguments = arguments.map{$0.toJSON()!}
                $0.blockID = Data(blockId)
            },
            success:{
                return CadenceValue.fromJSON($0.value)
            },
            completion: completion
        )
    }

    public func executeScriptAtBlockHeight(script: String, height: Int, arguments: [CadenceValue], completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_ExecuteScriptAtBlockHeightRequest,Flow_Access_ExecuteScriptResponse>
            .with(self.transport.client.executeScriptAtBlockHeight,
            transform:{
                $0.script = script.data(using: .utf8)!
                $0.arguments = arguments.map{$0.toJSON()!}
                $0.blockHeight = UInt64(height)
            },
            success:{
                return CadenceValue.fromJSON($0.value)
            },
            completion: completion
        )
    }

    public func getNetworkParameters(completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetNetworkParametersRequest,Flow_Access_GetNetworkParametersResponse>
            .with(self.transport.client.getNetworkParameters,
            transform:{_ in
            },
            success:{_ in
                return FlowEntity()
            },
            completion: completion
        )
    }

    public func getLatestProtocolStateSnapshot(completion: @escaping (ResultCallback)) {
        GRPCTransport.GRPCRequest<Flow_Access_GetLatestProtocolStateSnapshotRequest,Flow_Access_ProtocolStateSnapshotResponse>
            .with(self.transport.client.getLatestProtocolStateSnapshot,
            transform:{_ in
            },
            success:{_ in
                return FlowEntity()
            },
            completion: completion
        )
    }
    
}



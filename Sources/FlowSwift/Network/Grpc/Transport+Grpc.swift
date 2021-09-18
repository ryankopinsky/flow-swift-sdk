import Foundation
import Flow
import GRPC
import SwiftProtobuf
import NIOCore

public class GRPCTransport{
    public var client: Flow_Access_AccessAPIClient
    public var channel: GRPCChannel
    
    
    public init(host: String, port: Int){
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        self.channel = ClientConnection.insecure(group: group).connect(host: host, port: port)
        self.client = Flow_Access_AccessAPIClient(channel: channel)
    }

    public class GRPCRequest<PR: SwiftProtobuf.Message, RR: SwiftProtobuf.Message>{
        public static func with(_ function: (PR,GRPC.CallOptions?)->GRPC.UnaryCall<PR, RR>,
                                transform: @escaping((inout PR) -> Void),
                                success: @escaping(RR) -> FlowEntity?,
                                completion: @escaping(RpcResponse<FlowEntity>) -> Void
        ) -> Void {
            var message: PR = PR()
            transform(&message)
            let result = function(message,nil)
            let response = result.response
            response.whenFailure{
                error in
                completion(RpcResponse(result: nil, error: error))
            }
            response.whenSuccess{
                rawResponse in
                completion(RpcResponse(result: success(rawResponse), error:nil))
            }
        }
    }
    
}
    



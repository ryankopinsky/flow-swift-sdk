import Foundation

public class MemoryKeychain: FlowKeyChainProtocol{
    
    public init(){
        
    }
    enum KeyChainError: Error{
        case accountNotFound
    }
    
    public var keys: [String:KeyGroup] = [:]
    
    public func addKey(address: FlowAddress, key:FlowKey){
        if !self.keys.keys.contains(address.hex){
            self.keys[address.hex] = KeyGroup()
        }
        self.keys[address.hex]!.keys.append(key)
    }
    public func removeKey(address: FlowAddress, key:FlowKey){
        var group = self.keys[address.hex]!
        group.remove(key)
    }
    
    public func getKeyGroup(address: FlowAddress) throws-> KeyGroup{
        if !self.keys.keys.contains(address.hex){
            throw KeyChainError.accountNotFound
        }
        return self.keys[address.hex]!
    }
    
    public func signData(signerIndex: Int, address: FlowAddress, payload: Data) throws-> FlowTransactionSignature{
        
        
        guard let signerKey = try self.getKeyGroup(address: address).keys.first else {
            throw KeyChainError.accountNotFound
        }
        
        let signature = FlowSigner.signData(payload,
                                            privateKey: signerKey.key.data(using: .hexadecimal)!,
                                            signatureAlgorithm: signerKey.signingAlgorithm,
                                            hashAlgorithm: signerKey.hashAlgorithm)
        
        return FlowTransactionSignature(signerIndex: signerIndex,
                                        address: address,
                                        keyId: signerKey.keyId,
                                        signature: signature)
    }
    

    
}

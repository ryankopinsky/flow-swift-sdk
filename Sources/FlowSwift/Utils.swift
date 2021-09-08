//
//  Utils.swift
//  
//
//  Created by Ryan Kopinsky on 9/8/21.
//

import Foundation

// MARK: - HexString <> Data
// Reference: https://stackoverflow.com/a/56870030
extension String {
    enum ExtendedEncoding {
        case hexadecimal
    }
    
    func data(using encoding: ExtendedEncoding) -> Data? {
        let hexString = self.dropFirst(self.hasPrefix("0x") ? 2 : 0)
        
        guard hexString.count % 2 == 0 else { return nil }
        
        var data = Data(capacity: hexString.count/2)
        
        var indexIsEven = true
        for i in hexString.indices {
            if indexIsEven {
                let byteRange = i...hexString.index(after: i)
                guard let byte = UInt8(hexString[byteRange], radix: 16) else { return nil }
                data.append(byte)
            }
            indexIsEven.toggle()
        }
        return data
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }

    func hexString(prefixed isPrefixed: Bool = true) -> String {
        return self.bytes.reduce(isPrefixed ? "0x" : "") { $0 + String(format: "%02X", $1).lowercased() }
    }
}


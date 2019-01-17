//
//  AES.swift
//  UltimateLog
//
//  Created by Peigen.Liu on 1/14/19.
//  Copyright © 2019 Peigen.Liu. All rights reserved.
//

import Foundation





struct AES {
    static func encrypt( string: String, keyData : Data) -> String? {
        
        let strData = string.data(using: .utf8)
        let encrypted = strData?.encrypt(keyData: keyData)
        return encrypted?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension Data{
    
    func encrypt( keyData: Data) -> Data {
        let dataLength      = self.count
        let cryptLength     = size_t(dataLength + kCCBlockSizeAES128)
        var cryptData       = Data(count:cryptLength)
        let ivData          = "ABCDEFGHIJKLMNOP".data(using: .utf8)!   // 16 bytes for AES128

        let keyLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            self.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(kCCEncrypt),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, dataLength,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            
        } else {
            print("Error: \(cryptStatus)")
        }
        
        return cryptData;
    }
    
}

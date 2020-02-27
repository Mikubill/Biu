//
//  String.swift
//  Biu
//
//  Created by Ayari on 2019/09/30.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation

extension String {
    public func emptyToNil() -> String? {
        return self == "" ? nil : self
    }
    
    public func blankToNil() -> String? {
        return self.trimmingCharacters(in: .whitespacesAndNewlines) == "" ? nil : self
    }
    
    public func xor(key: UInt8) -> String? {
        let text = [UInt8](self.utf8)
        var encrypted = [UInt8]()
        for t in text.enumerated() {
            encrypted.append(t.element ^ key)
        }
        return String(bytes: encrypted, encoding: String.Encoding.utf8)
    }
}

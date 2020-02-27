//
//  AppStateUtils.swift
//  Biu
//
//  Created by Ayari on 2019/10/03.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import AVFoundation

extension AppState {
    
    func calc(_ i:Int) -> (String, String) {
        let min = String(Int(i / 60))
        let sec = String(Int(i % 60))
        return (stringify(min),  stringify(sec))
    }
    
    func stringify(_ c:String) -> String {
        if c.count == 1 {
            return "0\(c)"
        } else if c.count > 3 {
            return "00"
        } else {
            return c
        }
    }
}

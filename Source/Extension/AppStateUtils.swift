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

    func calc(_ seconds: Int) -> (String, String) {
        let min = String(Int(seconds / 60))
        let sec = String(Int(seconds % 60))
        return (stringify(min), stringify(sec))
    }

    func stringify(_ text: String) -> String {
        if text.count == 1 {
            return "0\(text)"
        } else if text.count > 3 {
            return "00"
        } else {
            return text
        }
    }
}

//
//  LyricsItem.swift
//  Biu
//
//  Created by Ayari on 2019/10/03.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation

public class LyricItem {
    
    public init(time: TimeInterval, text: String = "") {
        self.time = time
        self.text = text
    }
    
    public var time: TimeInterval
    public var text: String
}

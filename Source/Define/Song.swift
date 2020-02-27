//
//  Song.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation

public struct Song {
    public var id: String = ""
    public var title: String = ""
    public var singer: String = ""
    public var album: String = ""
    public var like: Bool = false
    public var lyric: [LyricItem]?
}

//
//  PlayerState.swift
//  Biu
//
//  Created by Ayari on 2019/09/29.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation

final class PlayerState: ObservableObject {

    @Published var playerIsOn = false
    @Published var playerIsOnSp = false
    @Published var playerIsOnIns = false
    @Published var playListOneIsOn = false
    @Published var collectionOneIsOn = false

}

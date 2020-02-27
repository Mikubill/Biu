//
//  PlayerState.swift
//  Biu
//
//  Created by Ayari on 2019/09/29.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation

final class PlayerState: ObservableObject {

    @Published var PlayerIsOn = false
    @Published var PlayerIsOnSp = false
    @Published var PlayerIsOnIns = false
    @Published var PlayListOneIsOn = false
    @Published var CollectionOneIsOn = false
    
}

//
//  AVPlayer.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    func stop() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.0, preferredTimescale: timeScale)
        self.seek(to: time)
        self.pause()
        self.cancelPendingPrerolls()
        self.replaceCurrentItem(with: nil)
    }
}

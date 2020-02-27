//
//  AppState.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: - CachingPlayerItemDelegate
extension AppState: CachingPlayerItemDelegate {
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        // A track is downloaded. Saving it to the cache asynchronously.
        if !self.radioIsOnInternal {
            debugPrint("Save: \(String(describing: url!.absoluteString)) saved to HybridStorage.")
            Variable.storage?.async.setObject(data, forKey: url!.absoluteString, completion: { _ in})
        } else {
            debugPrint("Save: \(String(describing: url!.absoluteString)) saved to FlashStorage.")
            Variable.flash?.async.setObject(data, forKey: url!.absoluteString, completion: { _ in})
        }
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        debugPrint(error)

        DispatchQueue.main.async {
            self.playerLock = false
            self.push()
        }
    }
}

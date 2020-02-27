//
//  CacheWorker.swift
//  Biu
//
//  Created by Ayari on 2019/10/03.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import AVFoundation

extension AppState {

    func worker(with url: URL) {
        if var path = URLComponents(string: url.absoluteString) {
            path.query = nil
            self.url = path.url
            print(self.url!)
        }
        let storage = self.radioIsOnInternal ? Variable.flash : Variable.storage
        // debugPrint("Cache Entry: \(String(describing: storage))")
        // Trying to retrieve a track from cache asynchronously.
        storage?.async.entry(forKey: self.url!.absoluteString, completion: { result in
            let playerItem: CachingPlayerItem
            switch result {
            case .error:
                // The track is not cached.
                debugPrint("The track is not cached.")
                playerItem = CachingPlayerItem(url: url)
            case .value(let entry):
                // The track is cached.
                debugPrint("The track is cached.")
                if url.absoluteString.contains(".mp3") {
                    playerItem = CachingPlayerItem(data: entry.object, mimeType: "audio/mpeg", fileExtension: "mp3")
                } else if url.absoluteString.contains(".m4a") {
                    playerItem = CachingPlayerItem(data: entry.object, mimeType: "audio/mp4", fileExtension: "m4a")
                } else {
                    playerItem = CachingPlayerItem(data: entry.object, mimeType: "audio/mpeg", fileExtension: "mp3")
                }
            }
            playerItem.delegate = self as CachingPlayerItemDelegate
            Constants.worker.async {
                self.removePeriodicTimeObserver()
                self.timeObserverToken = nil
                self.readyObserverToken = nil
//                self.player = nil
//                self.player.stop()
//                self.player.replaceCurrentItem(with: playerItem)
                self.player = AVPlayer(playerItem: playerItem)
                self.player.automaticallyWaitsToMinimizeStalling = false

                self.readyObserverToken = self.player.observe(\.status) { _, _ in
                    if self.player.status == AVPlayer.Status.readyToPlay {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                            // Start to play
                            self.player.play()
                            self.setupNowPlaying()
                            self.setupRemoteTransportControls()
                            self.addPeriodicTimeObserver()
                            self.addPlayToEndObserver()
                            self.isLoading = false
                        }
                    }
                }
            }
        })
    }
}

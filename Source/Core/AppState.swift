//
//  AppState.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftyJSON
import MediaPlayer
import Kingfisher
import Alamofire

final class AppState: NSObject, ObservableObject {

    @Published var playlist = [Song]()
    @Published var isPlaying: Bool = false
    @Published var nowPlaying: Song?
    @Published var identifier: Int = 0
    @Published var fmmode: Int = -1
    @Published var isLikeing: Bool = false
    @Published var isLoading: Bool = false
    @Published var radioIsLoading: Bool = false
    @Published var radioIsOn: Bool = false
    @Published var randomPlay: Bool = false
    @Published var userModifing: Bool = false
    @Published var radioCachePolicy: Bool = false

    var lyricLine: String = "..."
    var url: URL?
    var timeObserverToken: Any?
    var readyObserverToken: Any?
    var finishToken: Any?
    var playerLock = false
    var player: AVPlayer! = AVPlayer()
    var radioInitLoad = false
    var radioIsOnInternal = false
    var timestamp: ((String, String), (String, String)) = (("00", "00"), ("00", "00"))
    var during: Double = 0.0

    func start(for song: Song) {
        let id = song.id
        if self.radioIsOn {
            self.radioIsOnInternal = false
            self.radioIsOn = false
            self.fmmode = -1
            self.playlist = [Song]()
        }

        if self.playlist.count > 0 {

            if id == playlist[self.identifier].id {
                return
            } else {
                self.player.pause()
                self.playlist.append(song)
                self.identifier = self.playlist.count - 1
            }
        } else {
            self.playlist.append(song)
            self.identifier = 0
        }
        self.play()
    }

    func add(for song: Song) {
        print(playlist)
        playlist.append(song)

        if playlist.count == 1 {
            self.identifier = 0
            self.play()
        }
    }

    func play() {

        if self.playerLock {
            return
        }
        self.playerLock = true
        self.isLoading = true
        self.player.stop()
        self.nowPlaying = self.playlist[self.identifier]
//        self.lyricToGo()
        self.setupNowPlaying()
        self.lyricLine = "..."
        debugPrint("Start: \(self.playlist[self.identifier].id)")

        Constants.session.request(Router.getSongTickets(songid: self.playlist[self.identifier].id))
            .validate().responseJSON { response in self.playHandler(response) }
    }

    func lyricToGo() {
        Constants.session.request(Router.getLrc(songid: self.playlist[self.identifier].id))
            .validate().responseData { response in self.lyricHandler(response) }
    }

    func addMyCollection(_ index: Int) {
        var playlist = [Song]()
        for id in Variable.myPlaylistTitle[index].indices {
            // Make a Song
            playlist.append(Song(id: Variable.myPlaylistTitle[index][id]))
        }
        if self.randomPlay {
            playlist.shuffle()
        }
        if self.playlist.count == 0 {
            self.playlist.append(contentsOf: playlist)
            self.identifier = 0
            self.play()
        } else {
            self.playlist.append(contentsOf: playlist)
        }

    }

    func shuffle() {
        if self.playlist.count == 0 {
            return
        }
        self.playlist.remove(at: self.identifier)
        self.playlist.shuffle()
        if let music = self.nowPlaying {
            self.playlist.insert(music, at: self.identifier)
        }
    }

    func replaceMyCollection(_ index: Int) {
        if self.radioIsOn {
            self.radioIsOn = false
            self.fmmode = -1
            self.playlist = [Song]()
        }
        self.player.pause()
        var playlist = [Song]()
        for id in Variable.myPlaylistTitle[index].indices {
            // Make a Song
            playlist.append(Song(id: Variable.myPlaylistTitle[index][id]))
        }
        if self.randomPlay {
            playlist.shuffle()
        }
        self.playlist = playlist
        self.identifier = 0
        self.play()
    }

    func push() {
        if self.playlist.count == 0 {
            return
        }
        if self.playerLock {
            return
        }
        self.isLoading = true
        self.isPlaying = false
        self.player.stop()
        if self.radioIsOn, self.playlist.count - self.identifier < 3 {
            self.FMAddon()
        }
        if self.identifier >= 0, self.identifier < playlist.count - 1 {
            self.identifier += 1
            self.play()
            return
        }
        if self.identifier == playlist.count - 1 {
            self.identifier = 0
            self.play()
            return
        }
    }

    func set(_ index: Int) {
        if self.playerLock {
            return
        }
        self.isPlaying = false
        self.player.stop()
        if index >= 0, index <= self.playlist.count - 1 {
            self.identifier = index
            //            debugPrint(index, self.Playlist)
            self.play()
        }
    }

    func pull() {
        if self.playlist.count == 0 {
            return
        }
        if self.playerLock {
            return
        }
        self.isLoading = true
        self.isPlaying = false
        self.player.stop()
        if self.identifier > 0, self.identifier <= playlist.count - 1 {
            self.identifier -= 1
            self.play()
        }
        if self.identifier == 0 {
            self.identifier = playlist.count - 1
            self.play()
            return
        }
    }

    func forceUpdateLikeData(_ index: String) {
        Constants.session.request(Router.getLike)
            .validate().responseJSON { response in self.updateHandler(index, response) }
    }

    func userModified(_ state: Bool, dest: Double) {
        if !state {
            if let item = self.player.currentItem {
                let second = CMTimeScale(NSEC_PER_SEC)
                let timeScale = Int64(item.asset.duration.timescale)
                let seconds = Int64(item.asset.duration.value)
                let time = CMTime(seconds: Double(seconds / timeScale) * dest, preferredTimescale: second)
                self.player.seek(to: time)
            } else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.setupNowPlaying()
                self.userModifing = false
            }
        } else {
            self.userModifing = true
        }
    }

    func playingtoggle() {
        if self.playlist.count == 0 {
            return
        }

        if isPlaying {
            self.isPlaying = false
            self.player.pause()
        } else {
            if timeObserverToken == nil {
                addPeriodicTimeObserver()
            }
            self.isPlaying = true
            self.player.play()
        }

    }

    @objc func playToEnd(notification: NSNotification) {
        debugPrint("NextAudio was Called")
        if self.radioIsOn, self.playlist.count < 9 {
            self.FMAddon()
        }
        if self.playlist.count > 0 {
            self.push()
        } else {
            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 0.0, preferredTimescale: timeScale)
            self.player.seek(to: time)
            self.removePeriodicTimeObserver()
        }
    }

    func sleep(_ interval: Int) {
        if Variable.timer != nil {
            Variable.timer!.invalidate()
        }
        Variable.timeDate = Date.init(timeIntervalSinceNow: TimeInterval(interval * 60))
        Variable.timer = Timer.init(fire: Variable.timeDate!, interval: 2, repeats: false) { timer in
            self.player.pause()
            timer.invalidate()
            Variable.timer = nil
            Variable.timeDate = nil
        }
        RunLoop.current.add(Variable.timer!, forMode: RunLoop.Mode.default)
        //        Variable.timer!.fire()
    }

    func cancelsleep() {
        if Variable.timer != nil {
            Variable.timer!.invalidate()
        }
        Variable.timer = nil
        Variable.timeDate = nil
    }

    func addlike(_ index: String) {
        self.isLikeing = true
        Constants.session.request(Router.addLike(songid: index))
            .validate().responseJSON { _ in self.forceUpdateLikeData(index) }
    }

    func dellike(_ index: String) {
        self.isLikeing = true
        Constants.session.request(Router.delLike(songid: index))
            .validate().responseJSON { _ in self.forceUpdateLikeData(index) }
    }

    func FMON(_ rid: Int) {
        if self.radioIsLoading {
            return
        }
        self.radioIsLoading = true
        self.radioInitLoad = true
        self.radioIsOnInternal = true
        self.fmmode = rid
        //        self.playerLock = true
        self.player.stop()
        self.FMFetch()
    }

    func FMAddon() {
        Constants.worker.async {
            debugPrint("Start: FMAddon \(self.fmmode)")
            Constants.session.request(Router.getFMData(category: self.fmmode))
                .validate().responseJSON { response in self.radioHandler(response) }
        }
    }

    func FMFetch() {
        self.isLoading = true
        debugPrint("Start: FMFetch \(self.fmmode)")
        Constants.session.request(Router.getFMData(category: self.fmmode))
            .validate().responseJSON { response in self.radioHandler(response) }
    }

    func updateListInfo() {
        print("Called UpdateListInfo")
        if self.playlist.count == 0 {
            return
        }
        var request = ""
        let localRange = range()
        for item in localRange {
            request += self.playlist[item].id
            request += ","
        }
        Constants.session.request(Router.getSongDetails(songid: request))
            .validate().responseJSON { response in self.infoHandler(localRange, response) }
    }

    func range() -> ClosedRange<Int> {
        let localIndex = self.identifier
        if self.playlist.count > 200 {
            if localIndex < 30 {
                return 0...localIndex + 30
            } else {
                if localIndex < self.playlist.count - 31 {
                    return localIndex - 30...localIndex + 30
                } else {
                    return localIndex - 30...self.playlist.count - 1
                }
            }
        } else {
            return 0...self.playlist.count - 1
        }
    }

    func addPeriodicTimeObserver() {
        // Notify every half second
        let time = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        timeObserverToken = self.player
            .addPeriodicTimeObserver(
                forInterval: time,
                queue: Constants.worker
            ) { time in

                // update player transport UI
                let rawDuring = self.player.currentItem?.asset.duration.value ?? 0
                let rawScale = self.player.currentItem?.asset.duration.timescale
                let now = time.value - rawDuring
                let timestamp = Float(now < Int64(0) ? Int64(0) : now) / Float(time.timescale)
                let ot = Double(rawDuring) / Double(rawScale ?? time.timescale)
                self.timestamp = (self.calc(Int(timestamp)), self.calc(Int(ot)))

                if !self.userModifing {
                    self.during = Double(timestamp)/Double(ot)
                }
                //                debugPrint(self.timestamp)
                // Use the observer to update lryics
                //                if let lyric = self.NowSong?.lyric {
                //                    for i in lyric.indices {
                //                        let s = Float(lyric[i].time) - timestamp
                //                        if s > 0, s < 0.2 {
                //                            debugPrint(lyric[i].time, timestamp, lyric[i].text)
                //                            if lyric[i].text != "" {
                //                                self.NowLyric = lyric[i].text
                //                            } else {
                //                                self.NowLyric = "..."
                //                            }
                //                            break
                //                        }
                //                    }
                //                }
        }
    }

    func addPlayToEndObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playToEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem)
    }

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            self.player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] _ in
            if self.player.rate == 0.0 {
                self.isPlaying = true
                self.player.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.player.rate == 1.0 {
                self.isPlaying = false
                self.player.pause()
                return .success
            }
            return .commandFailed
        }

        commandCenter.nextTrackCommand.addTarget { [unowned self] _ in
            self.push()
            return .success
        }

        commandCenter.previousTrackCommand.addTarget { [unowned self] _ in
            self.pull()
            return .success
        }

        commandCenter.changePlaybackPositionCommand.addTarget {
            [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
            guard let self = self else {return .commandFailed}
            if let player = self.player {
                let playerRate = player.rate
                if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
                    player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)),
                                completionHandler: { [weak self](success) in
                                    guard let self = self else {return}
                                    if success {
                                        self.player?.rate = playerRate
                                    }
                    })
                    return .success
                }
            }
            return .commandFailed
        }

    }

    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.playlist[self.identifier].title
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.playlist[self.identifier].singer
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        let url = URL(string: "\(Router.biuBaseAPICover)/\(self.playlist[self.identifier].id )")!

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let image: UIImage = value.image
                nowPlayingInfo[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { _ in
                        return image
                }
                let rawSecond = self.player.currentItem?.currentTime().seconds
                let rawDuration = self.player.currentItem?.asset.duration.seconds
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = rawSecond
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = rawDuration
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func lyricHandler(_ response: AFDataResponse<Data>) {
        switch response.result {
        case .success(let data):
            if let object = String(data: data, encoding: .utf8) {
                if object != "没歌词" {
                    self.nowPlaying?.lyric = LyricsParser(lyrics: object).lyrics
                    //                debugPrint(self.NowSong?.lyric)
                } else {
                    self.lyricLine = "没歌词"
                }
            }
        case .failure(let error):
            debugPrint(error)

        }
    }

    func playHandler(_ response: AFDataResponse<Any>) {
        switch response.result {
        case .success(let data):
            self.removePeriodicTimeObserver()
            let url = songpairs(JSON(data))!
            self.worker(with: URL(string: url)!)
            self.playlist[self.identifier] = songFullPairs(JSON(data))
            self.nowPlaying = self.playlist[self.identifier]
            self.isPlaying = true

        case .failure(let error):
            debugPrint(error)

        }
        self.playerLock = false
    }

    func updateHandler(_ index: String, _ response: AFDataResponse<Any>) {
        //        debugPrint(response.debugDescription)
        switch response.result {
        case .success(let data):
            //            debugPrint(SongFullPairsLike(index, JSON(data)))
            self.nowPlaying?.like = songFullPairsLike(index, JSON(data))
        case .failure(let error):
            debugPrint(error)
        }
        self.isLikeing = false
    }

    func radioHandler(_ response: AFDataResponse<Any>) {
        debugPrint("Start: FMHandler \(self.fmmode)")
        switch response.result {
        case .success(let data):
            if self.radioIsOn, !self.radioInitLoad {
                self.playlist.append(contentsOf: jsonResultParser(JSON(data)))
            } else {
                self.playlist = jsonResultParser(JSON(data))
                self.identifier = 0
                self.radioIsOn = true
                self.nowPlaying = self.playlist[self.identifier]
                debugPrint(self.playlist)
                self.play()
            }
        case .failure(let error):
            debugPrint(error)
        }
        debugPrint(self.playlist)
        self.radioIsLoading = false
        self.radioInitLoad = false
    }

    func infoHandler(_ localRanger: ClosedRange<Int>, _ response: AFDataResponse<Any>) {
        guard let object = response.data else {
            return
        }
        let json = JSON(object)
        guard json["status"] == true else {
            return
        }
        let answer = jsonResultParser(json["result"])
        var counter = 0
        if answer.count > 0 {
            for index in localRanger {
                if counter < self.playlist.count && counter < answer.count {
                    if self.playlist[index].id == answer[counter].id {
                        self.playlist[index] = answer[counter]
                    }
                }
                counter += 1
            }
        }
    }

}

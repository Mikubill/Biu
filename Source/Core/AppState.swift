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
    
    @Published var Playlist = [Song]()
    @Published var isPlaying: Bool = false
    @Published var NowSong: Song? = nil
    @Published var identifier: Int = 0
    @Published var fmmode: Int = -1
    @Published var isLikeing: Bool = false
    @Published var isLoading: Bool = false
    @Published var FMisLoading: Bool = false
    @Published var FMisOn: Bool = false
    @Published var RandomPlay: Bool = false
    @Published var UserChanging: Bool = false
    @Published var CacheRadio: Bool = false
    
    var NowLyric: String = "..."
    var url: URL?
    var timeObserverToken: Any?
    var readyObserverToken: Any?
    var FinishToken: Any?
    var playerLock = false
    var player: AVPlayer! = AVPlayer()
    var FMinitLoad = false
    var FMisOnInternal = false
    var timestamp: ((String, String), (String, String)) = (("00", "00"), ("00", "00"))
    var during: Double = 0.0
    
    func start(for song: Song) {
        let id = song.id
        if self.FMisOn {
            self.FMisOnInternal = false
            self.FMisOn = false
            self.fmmode = -1
            self.Playlist = [Song]()
        }
        
        if self.Playlist.count > 0 {
            
            if id == Playlist[self.identifier].id {
                return
            } else {
                self.player.pause()
                self.Playlist.append(song)
                self.identifier = self.Playlist.count - 1
            }
        } else {
            self.Playlist.append(song)
            self.identifier = 0
        }
        self.play()
    }
    
    func add(for song: Song) {
        print(Playlist)
        Playlist.append(song)
        
        if Playlist.count == 1 {
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
        self.NowSong = self.Playlist[self.identifier]
        self.LyricGo()
        self.setupNowPlaying()
        self.NowLyric = "..."
        debugPrint("Start: \(self.Playlist[self.identifier].id)")
        
        Constants.S.request(Router.GetSongTickets(Songid: self.Playlist[self.identifier].id))
            .validate().responseJSON() { response in self.playHandler(response) }
    }
    
    
    
    func LyricGo() {
        Constants.S.request(Router.GetLrc(Songid: self.Playlist[self.identifier].id))
            .validate().responseData() { response in self.LyricHandler(response) }
    }
    
    
    
    func addMyCollection(_ i: Int) {
        var p = [Song]()
        for id in Variable.my_music_list_title[i].indices {
            // Make a Song
            p.append(Song(id: Variable.my_music_list_title[i][id]))
        }
        if self.RandomPlay {
            p.shuffle()
        }
        if self.Playlist.count == 0 {
            self.Playlist.append(contentsOf: p)
            self.identifier = 0
            self.play()
        }
        else {
            self.Playlist.append(contentsOf: p)
        }
        
    }
    
    func shuffle() {
        if self.Playlist.count == 0 {
            return
        }
        self.Playlist.remove(at: self.identifier)
        self.Playlist.shuffle()
        if let p = self.NowSong {
            self.Playlist.insert(p, at: self.identifier)
        }
    }
    
    func replaceMyCollection(_ i: Int) {
        if self.FMisOn {
            self.FMisOn = false
            self.fmmode = -1
            self.Playlist = [Song]()
        }
        self.player.pause()
        var p = [Song]()
        for id in Variable.my_music_list_title[i].indices {
            // Make a Song
            p.append(Song(id: Variable.my_music_list_title[i][id]))
        }
        if self.RandomPlay {
            p.shuffle()
        }
        self.Playlist = p
        self.identifier = 0
        self.play()
    }
    
    
    func push() {
        if self.Playlist.count == 0 {
            return
        }
        if self.playerLock {
            return
        }
        self.isLoading = true
        self.isPlaying = false
        self.player.stop()
        if self.FMisOn, self.Playlist.count - self.identifier < 3 {
            self.FMAddon()
        }
        if self.identifier >= 0,self.identifier < Playlist.count - 1 {
            self.identifier += 1
            self.play()
            return
        }
        if self.identifier == Playlist.count - 1 {
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
        if index >= 0, index <= self.Playlist.count - 1 {
            self.identifier = index
//            debugPrint(index, self.Playlist)
            self.play()
        }
    }
    
    func pull() {
        if self.Playlist.count == 0 {
            return
        }
        if self.playerLock {
            return
        }
        self.isLoading = true
        self.isPlaying = false
        self.player.stop()
        if self.identifier > 0,self.identifier <= Playlist.count - 1 {
            self.identifier -= 1
            self.play()
        }
        if self.identifier == 0 {
            self.identifier = Playlist.count - 1
            self.play()
            return
        }
    }
    
    func ForceUpdateLikeData(_ index: String) {
        Constants.S.request(Router.GetLike)
            .validate().responseJSON() { response in self.UpdateHandler(index, response) }
    }
    
    func UserChanged(_ state: Bool, dest: Double) {
        if !state {
            if let p = self.player.currentItem {
                let ts = CMTimeScale(NSEC_PER_SEC)
                let timeScale = Int64(p.asset.duration.timescale)
                let seconds = Int64(p.asset.duration.value)
                let time = CMTime(seconds: Double(seconds / timeScale) * dest, preferredTimescale: ts)
                self.player.seek(to: time)
            } else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.setupNowPlaying()
                self.UserChanging = false
            }
        } else {
            self.UserChanging = true
        }
    }
    
    func Playingtoggle() {
        if self.Playlist.count == 0 {
            return
        }
        
        if isPlaying {
            self.isPlaying = false
            self.player.pause()
        } else  {
            if timeObserverToken == nil {
                addPeriodicTimeObserver()
            }
            self.isPlaying = true
            self.player.play()
        }
        
    }
    
    @objc func playToEnd(notification:NSNotification) {
        debugPrint("NextAudio was Called")
        if self.FMisOn, self.Playlist.count < 9 {
            self.FMAddon()
        }
        if self.Playlist.count > 0 {
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
        Constants.S.request(Router.AddLike(Songid: index))
            .validate().responseJSON() { response in self.ForceUpdateLikeData(index) }
    }
    
    func dellike(_ index: String) {
        self.isLikeing = true
        Constants.S.request(Router.DelLike(Songid: index))
            .validate().responseJSON() { response in self.ForceUpdateLikeData(index) }
    }
    
    
    func FMON(_ rid: Int) {
        if self.FMisLoading {
            return
        }
        self.FMisLoading = true
        self.FMinitLoad = true
        self.FMisOnInternal = true
        self.fmmode = rid
        //        self.playerLock = true
        self.player.stop()
        self.FMFetch()
    }
    
    func FMAddon() {
        Constants.worker.async {
            debugPrint("Start: FMAddon \(self.fmmode)")
            Constants.S.request(Router.GetFMData(Category: self.fmmode))
                .validate().responseJSON() { response in self.FMHandler(response) }
        }
    }
    
    func FMFetch() {
        self.isLoading = true
        debugPrint("Start: FMFetch \(self.fmmode)")
        Constants.S.request(Router.GetFMData(Category: self.fmmode))
            .validate().responseJSON() { response in self.FMHandler(response) }
    }
    
    func UpdateListInfo() {
        print("Called UpdateListInfo")
        if self.Playlist.count == 0 {
            return
        }
        var request = ""
        let localRange = range()
        for i in localRange {
            request += self.Playlist[i].id
            request += ","
        }
        Constants.S.request(Router.GetSongDetails(Songid: request))
            .validate().responseJSON() { response in self.InfoHandler(localRange, response) }
    }
    
    func range() -> ClosedRange<Int> {
        let p = self.identifier
        if self.Playlist.count > 200 {
            if p < 30 {
                return 0...p + 30
            } else {
                if p < self.Playlist.count - 31 {
                    return p - 30...p + 30
                } else {
                    return p - 30...self.Playlist.count - 1
                }
            }
        } else {
            return 0...self.Playlist.count - 1
        }
    }
    
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let time = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = self.player
            .addPeriodicTimeObserver(
                forInterval: time,
                queue: Constants.worker
            ) {
                time in
                
                // update player transport UI
                let OriginalDuring = self.player.currentItem?.asset.duration.value ?? 0
                let OriginalScale = self.player.currentItem?.asset.duration.timescale
                let now = time.value - OriginalDuring
                let timestamp = Float(now < Int64(0) ? Int64(0) : now) / Float(time.timescale)
                let ot = Double(OriginalDuring) / Double(OriginalScale ?? time.timescale)
                self.timestamp = (self.calc(Int(timestamp)), self.calc(Int(ot)))
                
                if !self.UserChanging {
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
        NotificationCenter.default.addObserver(self, selector:#selector(self.playToEnd(notification:)),
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
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.isPlaying = true
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.isPlaying = false
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.push()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.pull()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
            guard let self = self else {return .commandFailed}
            if let player = self.player {
                let playerRate = player.rate
                if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
                    player.seek(to: CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000)), completionHandler: { [weak self](success) in
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
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.Playlist[self.identifier].title
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.Playlist[self.identifier].singer
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
        let url = URL(string: "\(Router.Biu_BaseAPI_Cover)/\(self.Playlist[self.identifier].id )")!
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let image:UIImage = value.image
                nowPlayingInfo[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { size in
                        return image
                }
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentItem?.currentTime().seconds
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.currentItem?.asset.duration.seconds
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    
    
    func LyricHandler(_ response: AFDataResponse<Data>) {
        switch response.result {
        case .success(let data):
            if let object = String(data: data, encoding: .utf8) {
                if object != "没歌词" {
                    self.NowSong?.lyric = LyricsParser(lyrics: object).lyrics
                    //                debugPrint(self.NowSong?.lyric)
                } else {
                    self.NowLyric = "没歌词"
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
            self.Playlist[self.identifier] = SongFullPairs(JSON(data))
            self.NowSong = self.Playlist[self.identifier]
            self.isPlaying = true
            
        case .failure(let error):
            debugPrint(error)
            
        }
        self.playerLock = false
    }
    
    func UpdateHandler(_ index: String, _ response: AFDataResponse<Any>) {
        //        debugPrint(response.debugDescription)
        switch response.result {
        case .success(let data):
            //            debugPrint(SongFullPairsLike(index, JSON(data)))
            self.NowSong?.like = SongFullPairsLike(index, JSON(data))
        case .failure(let error):
            debugPrint(error)
        }
        self.isLikeing = false
    }
    
    func FMHandler(_ response: AFDataResponse<Any>) {
        debugPrint("Start: FMHandler \(self.fmmode)")
        switch response.result {
        case .success(let data):
            if self.FMisOn,!self.FMinitLoad {
                self.Playlist.append(contentsOf: FMPairs(JSON(data)))
            } else {
                self.Playlist = FMPairs(JSON(data))
                self.identifier = 0
                self.FMisOn = true
                self.NowSong = self.Playlist[self.identifier]
                debugPrint(self.Playlist)
                self.play()
            }
        case .failure(let error):
            debugPrint(error)
        }
        debugPrint(self.Playlist)
        self.FMisLoading = false
        self.FMinitLoad = false
    }
    
    func InfoHandler(_ localRanger:ClosedRange<Int>, _ response: AFDataResponse<Any>) {
        guard let object = response.data else {
            return
        }
        let json = JSON(object)
        guard json["status"] == true else {
            return
        }
        let answer = FMPairs(json["result"])
        var counter = 0
        if answer.count > 0 {
            for index in localRanger {
                if counter < self.Playlist.count && counter < answer.count {
                    if self.Playlist[index].id == answer[counter].id {
                        self.Playlist[index] = answer[counter]
                    }
                }
                counter += 1
            }
        }
    }
    
}

//
//  utils.swift
//  Biu
//
//  Created by Ayari on 2019/09/25.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

func pairs(_ json:JSON) -> ([String], [Any]){
    var q:JSON
    var r = [String]()
    var b = [String]()
    var s = [[String]]()
    q = json["result"].exists() ? json["result"] : json
    for (_,subJson):(String, JSON) in q {
        for (key,subJson):(String, JSON) in subJson {
            switch key {
            case "title": r.append(subJson.string ?? "nil")
            case "sid": b.append(subJson.string ?? "1")
            case "sids": s.append(subJson.arrayValue.map { $0.string ?? "1" })
            default: break
            }
        }
    }
    return s == [] ? (r, b):(r, s)
}

func searchpairs(_ json:JSON) -> [Song] {
    var q:JSON
    var list = [Song]()
    q = json["result"].exists() ? json["result"] : json
    for (_,subJson):(String, JSON) in q {
        var song = Song()
        for (key,subJson):(String, JSON) in subJson {
            switch key {
            case "title": song.title = subJson.string ?? "nil"
            case "sid": song.id = subJson.string ?? "1"
            case "album": song.album = subJson.string ?? "nil"
            case "singer": song.singer = subJson.string ?? "nil"
            default: break
            }
        }
        list.append(song)
    }
    return list
}

func songpairs(_ json:JSON) -> String? {
    for (key, subJson):(String, JSON) in json {
        switch key {
        case "url": return subJson.string ?? nil
        default: break
        }
    }
    return nil
}

func SongFullPairs(_ json:JSON) -> Song {
    var song = Song()
    let q = json["result"].exists() ? json["result"] : json
    for (key, subJson):(String, JSON) in q {
        switch key {
        case "title": song.title = subJson.string ?? "nil"
        case "sid": song.id = subJson.string ?? "1"
        case "album": song.album = subJson.string ?? "nil"
        case "singer": song.singer = subJson.string ?? "nil"
        case "like":
            if let p = subJson.string {
                if p == "1" {
                    song.like = true
                } else {
                    song.like = false
                }
            }
        default: break
        }
    }
    return song
}

func SongFullPairsLike(_ index: String, _ json:JSON) -> Bool {
    if !json["result"][0]["sids"].exists() {
        return false
    } else {
        let q = json["result"][0]["sids"]
        for (_, subJson):(String, JSON) in q {
            if subJson.string == index {
                return true
            }
        }
    }
    return false
}

func FMPairs(_ json:JSON) -> [Song] {
    var finalsongs = [Song]()
    var songs = [Song]()
    for (_, subJson):(String, JSON) in json {
        var song = Song()
        for (key, subJson):(String, JSON) in subJson {
            switch key {
            case "title": song.title = subJson.string ?? "nil"
            case "sid": song.id = subJson.string ?? "1"
            case "album": song.album = subJson.string ?? "nil"
            case "singer": song.singer = subJson.string ?? "nil"
            default: break
            }
        }
        songs.append(song)
    }
    for i in songs.indices {
        if songs[i].id != "-1",songs[i].id != ""  {
            finalsongs.append(songs[i])
        }
    }
    return finalsongs
}

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

func pairs(_ json: JSON) -> ([String], [Any]) {
    var data: JSON
    var titles = [String]()
    var id = [String]()
    var ids = [[String]]()
    data = json["result"].exists() ? json["result"] : json
    for (_, subJson):(String, JSON) in data {
        for (key, subJson):(String, JSON) in subJson {
            switch key {
            case "title": titles.append(subJson.string ?? "nil")
            case "sid": id.append(subJson.string ?? "1")
            case "sids": ids.append(subJson.arrayValue.map { $0.string ?? "1" })
            default: break
            }
        }
    }
    return ids == [] ? (titles, id):(titles, ids)
}

func searchpairs(_ json: JSON) -> [Song] {
    var data: JSON
    var list = [Song]()
    data = json["result"].exists() ? json["result"] : json
    for (_, subJson):(String, JSON) in data {
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
        list.append(song)
    }
    return list
}

func songpairs(_ json: JSON) -> String? {
    for (key, subJson):(String, JSON) in json {
        switch key {
        case "url": return subJson.string ?? nil
        default: break
        }
    }
    return nil
}

func songFullPairs(_ json: JSON) -> Song {
    var song = Song()
    let rawResult = json["result"].exists() ? json["result"] : json
    for (key, subJson):(String, JSON) in rawResult {
        switch key {
        case "title": song.title = subJson.string ?? "nil"
        case "sid": song.id = subJson.string ?? "1"
        case "album": song.album = subJson.string ?? "nil"
        case "singer": song.singer = subJson.string ?? "nil"
        case "like":
            if let data = subJson.string {
                if data == "1" {
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

func songFullPairsLike(_ index: String, _ json: JSON) -> Bool {
    if !json["result"][0]["sids"].exists() {
        return false
    } else {
        let result = json["result"][0]["sids"]
        for (_, subJson):(String, JSON) in result {
            if subJson.string == index {
                return true
            }
        }
    }
    return false
}

func jsonResultParser(_ json: JSON) -> [Song] {
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
    for item in songs.indices {
        if songs[item].id != "-1", songs[item].id != "" {
            finalsongs.append(songs[item])
        }
    }
    return finalsongs
}

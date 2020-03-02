//
//  Variable.swift
//  Biu
//
//  Created by Ayari on 2019/09/25.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import Cache

struct Variable {
    static var myPlaylistKey = [String]()
    static var myPlaylistTitle = [[String]]()
//    static var newMusicPlaylistKey = [String]()
    static var newMusicPlaylist = [Song]()
//    static var hotMusicPlayListKey = [String]()
    static var hotMusicPlaylist = [Song]()

    static var timer: Timer?
    static var ntimer: Timer?
    static var timeDate: Date?

    static var flash: Cache.Storage? = {
        return try? Storage(diskConfig: Constants.shortdiskConfig, memoryConfig: Constants.shortmemoryConfig, transformer: TransformerFactory.forData())
    }()

    static var storage: Cache.Storage? = {
        return try? Storage(diskConfig: Constants.diskConfig, memoryConfig: Constants.memoryConfig, transformer: TransformerFactory.forData())
    }()

    static var diskstorage: Cache.DiskStorage? = {
        return try? DiskStorage(config: Constants.diskConfig, transformer: TransformerFactory.forData())
    }()

    static var ticketstorage: Cache.Storage? = {
        return try? Storage(diskConfig: Constants.ticketdiskConfig, memoryConfig: Constants.ticketmemoryConfig, transformer: TransformerFactory.forData())
    }()

    static var likecollect: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "likecollect") {
            if let stringTicket = String(data: ticket, encoding: .utf8) {
                return stringTicket
            }
        }
        return nil
    }()

    static var token: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "token") {
            if let stringTicket = String(data: ticket, encoding: .utf8) {
                return stringTicket
            }
        }
        return nil
    }()

    static var uid: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "uid") {
            if let stringTicket = String(data: ticket, encoding: .utf8) {
                return stringTicket
            }
        }
        return nil
    }()

    static var email: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "email") {
            if let stringTicket = String(data: ticket, encoding: .utf8) {
                return stringTicket
            }
        }
        return nil
    }()

    static var name: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "name") {
            if let stringTicket = String(data: ticket, encoding: .utf8) {
                return stringTicket
            }
        }
        return nil
    }()
}

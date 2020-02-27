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
    static var my_music_list_key = [String]()
    static var my_music_list_title = [[String]]()
    static var new_music_list_key = [String]()
    static var new_music_list_title = [String]()
    static var hot_music_list_key = [String]()
    static var hot_music_list_title = [String]()
    
    static var timer: Timer? = nil
    static var ntimer: Timer? = nil
    static var timeDate: Date? = nil
    
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
            if let StringTicket = String(data: ticket, encoding: .utf8) {
                return StringTicket
            }
        }
        return nil
    }()
    
    static var token: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "token") {
            if let StringTicket = String(data: ticket, encoding: .utf8) {
                return StringTicket
            }
        }
        return nil
    }()
    
    static var uid: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "uid") {
            if let StringTicket = String(data: ticket, encoding: .utf8) {
                return StringTicket
            }
        }
        return nil
    }()
    
    static var email: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "email") {
            if let StringTicket = String(data: ticket, encoding: .utf8) {
                return StringTicket
            }
        }
        return nil
    }()
    
    static var name: String? = {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "name") {
            if let StringTicket = String(data: ticket, encoding: .utf8) {
                return StringTicket
            }
        }
        return nil
    }()
}

//
//  Constants.swift
//  Biu
//
//  Created by Ayari on 2019/09/25.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import Kingfisher
import Cache
import Alamofire

struct Constants {
    static let imageCache = ImageCache.default
    static let diskConfig = DiskConfig(name: "DiskCache")
    static let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

    static let shortdiskConfig = DiskConfig(name: "FlashCache", expiry: .seconds(3600), maxSize: 1048576)
    static let shortmemoryConfig = MemoryConfig(expiry: .seconds(600), countLimit: 5, totalCostLimit: 5)

    static let ticketdiskConfig = DiskConfig(name: "Ticket", expiry: .never, protectionType: .complete)
    static let ticketmemoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

    static let worker = DispatchQueue(label: "worker", attributes: .concurrent)
    static let version: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let build: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    static let httpVia = "Biu iOS Client \(Constants.version ?? "Undefined")(\(Constants.build ?? "Undefined"))"

    static let session: Session  = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3
        return Session(configuration: configuration, interceptor: RequestHandler())
    }()
}

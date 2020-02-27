//
//  Router.swift
//  Biu
//
//  Created by Ayari on 2019/09/29.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum Router: URLRequestConvertible {
    case login(username: String, password: String)
    case signup(username: String, password: String, name: String)
    case getSongTickets(songid: String)
    case getSongsDetails(songid: [String])
    case getSongDetails(songid: String)
    case getLrc(songid: String)
    case addLike(songid: String)
    case delLike(songid: String)
    case search(query: String)
    case getFMData(category: Int)
    case getMyList
    case getNewList
    case getHotList
    case updateSelfInfo
    case getLike

    static let biuBaseAPIAndroid = getConfig(withName: "Android", cat: "Basic")
    static let biuBaseAPIPWA = getConfig(withName: "PWA", cat: "Basic")
    static let biuBaseAPIWeb = getConfig(withName: "Web", cat: "Basic")
    static let biuBaseAPIAvatar = getConfig(withName: "Avatar", cat: "App")
    static let biuBaseAPICover = getConfig(withName: "Cover", cat: "App")
    static let biuBaseAPIFMCover = getConfig(withName: "FMCover", cat: "App")
    static let biuBaseAPISignup = getConfig(withName: "Signup", cat: "App")
    static let biuBaseAPIFM = getConfig(withName: "FM", cat: "App")

    static let PublicHeaders: [String: String] = [
        "Accept": "application/json, text/plain, */*",
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent": "Biu/\(Constants.build ?? "Undefined") (\(UIDevice.current.model); \(UIDevice.current.systemName) \(UIDevice.current.systemVersion))"
    ]

    var headers: [String: String] {
        switch self {
        case .login:
            return ["Referer": Router.biuBaseAPIPWA]
        case .signup:
            return ["Referer": Router.biuBaseAPISignup]
        case .getFMData:
            return ["Referer": Router.biuBaseAPIFM]
        case .getLrc:
            return ["Referer": Router.biuBaseAPIFM]
        default:
            return [:]
        }
    }

    var baseURLString: String {
        switch self {
        case .login:
            return Router.biuBaseAPIAndroid
        case .updateSelfInfo:
            return Router.biuBaseAPIAndroid
        case .getMyList:
            return Router.biuBaseAPIAndroid
        case .getNewList:
            return Router.biuBaseAPIAndroid
        case .getHotList:
            return Router.biuBaseAPIAndroid
        case .getSongTickets:
            return Router.biuBaseAPIAndroid
        case .getSongDetails:
            return Router.biuBaseAPIAndroid
        case .getSongsDetails:
            return Router.biuBaseAPIAndroid
        case .getLike:
            return Router.biuBaseAPIAndroid
        case .addLike:
            return Router.biuBaseAPIAndroid
        case .delLike:
            return Router.biuBaseAPIAndroid
        case .search:
            return Router.biuBaseAPIAndroid
        case .getFMData:
            return Router.biuBaseAPIWeb
        case .getLrc:
            return Router.biuBaseAPIWeb
        case .signup:
            return Router.biuBaseAPIWeb
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signup:
            return .post
        case .login:
            return .post
        case .updateSelfInfo:
            return .post
        case .getLike:
            return .post
        case .getMyList:
            return .post
        case .getNewList:
            return .post
        case .getHotList:
            return .post
        case .getSongTickets:
            return .post
        case .getSongDetails:
            return .post
        case .getSongsDetails:
            return .post
        case .addLike:
            return .post
        case .search:
            return .post
        case .delLike:
            return .post
        case .getFMData:
            return .get
        case .getLrc:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getLike:
            return getConfig(withName: "GetLike", cat: "Route")
        case .updateSelfInfo:
            return getConfig(withName: "UpdateSelfInfo", cat: "Route")
        case .login:
            return getConfig(withName: "Login", cat: "Route")
        case .getMyList:
            return getConfig(withName: "GetMyList", cat: "Route")
        case .getNewList:
            return getConfig(withName: "GetNewList", cat: "Route")
        case .getHotList:
            return getConfig(withName: "GetHotList", cat: "Route")
        case .getSongTickets:
            return getConfig(withName: "GetSongTickets", cat: "Route")
        case .getSongDetails:
            return getConfig(withName: "GetSongDetails", cat: "Route")
        case .getSongsDetails:
            return getConfig(withName: "GetSongDetails", cat: "Route")
        case .addLike:
            return getConfig(withName: "AddLike", cat: "Route")
        case .delLike:
            return getConfig(withName: "DelLike", cat: "Route")
        case .search:
            return getConfig(withName: "Search", cat: "Route")
        case .getFMData:
            return getConfig(withName: "GetFMData", cat: "Route")
        case .getLrc:
            return getConfig(withName: "GetLrc", cat: "Route")
        case .signup:
            return getConfig(withName: "Signup", cat: "Route")
        }
    }

    var parameters: Parameters {
        switch self {
        case .signup(let username, let password, let name):
            return [
                "email": username,
                "password": password,
                "password2": password,
                "name": name,
                "qq": "",
                "gender": "X"
            ]
        case .getLike:
            return [
                "token": Variable.token ?? "",
                "lid": Variable.likecollect ?? ""
            ]
        case .updateSelfInfo:
            return [
                "token": Variable.token ?? ""
            ]
        case .login(let username, let password):
            return [
                "email": username,
                "password": password
            ]
        case .getMyList:
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? ""
            ]
        case .getNewList:
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? ""
            ]
        case .getHotList:
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? ""
            ]
        case .search(let query):
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? "",
                "search": query
            ]
        case .getSongTickets(let songid):
            return [
                "token": Variable.token ?? "",
                "sid": songid
            ]
        case .getSongDetails(let songid):
            return [
                "token": Variable.token ?? "",
                "sid": songid
            ]
        case .getSongsDetails(let songid):
            return [
                "token": Variable.token ?? "",
                "sid": String(songid.joined(separator: ","))
            ]
        case .addLike(let songid):
            return [
                "token": Variable.token ?? "",
                "sid": songid
            ]
        case .delLike(let songid):
            return [
                "token": Variable.token ?? "",
                "sid": songid
            ]
        case .getFMData(let category):
            return [
                "datacenter": "0",
                "rid": String(category),
                "_r": String(Double.random(in: 0...1))
            ]
        case .getLrc(let songid):
            return [
                "sid": songid
            ]
        }
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        headers.forEach {  urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        Router.PublicHeaders.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        debugPrint("Requested: \(urlRequest)")
        return urlRequest
    }
}

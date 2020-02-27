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
    case Login(username: String, password: String)
    case Signup(username: String, password: String, name: String)
    case GetSongTickets(Songid: String)
    case GetSongsDetails(Songid: [String])
    case GetSongDetails(Songid: String)
    case GetLrc(Songid: String)
    case AddLike(Songid: String)
    case DelLike(Songid: String)
    case Search(Query: String)
    case GetFMData(Category: Int)
    case GetMyList
    case GetNewList
    case GetHotList
    case UpdateSelfInfo
    case GetLike
    
    static let Biu_BaseAPI_Android = getConfig(withName: "Android", cat: "Basic")
    static let Biu_BaseAPI_PWA = getConfig(withName: "PWA", cat: "Basic")
    static let Biu_BaseAPI_Web = getConfig(withName: "Web", cat: "Basic")
    static let Biu_BaseAPI_Avatar = getConfig(withName: "Avatar", cat: "App")
    static let Biu_BaseAPI_Cover = getConfig(withName: "Cover", cat: "App")
    static let Biu_BaseAPI_FMCover = getConfig(withName: "FMCover", cat: "App")
    static let Biu_BaseAPI_Signup = getConfig(withName: "Signup", cat: "App")
    static let Biu_BaseAPI_FM = getConfig(withName: "FM", cat: "App")
    
    static let PublicHeaders: [String: String] = [
        "Accept": "application/json, text/plain, */*",
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent": "Biu/\(Constants.build ?? "Undefined") (\(UIDevice.current.model); \(UIDevice.current.systemName) \(UIDevice.current.systemVersion))",
    ]
    
    var headers: [String: String] {
        switch self {
        case .Login(_):
            return ["Referer": Router.Biu_BaseAPI_PWA]
        case .Signup(_, _, _):
            return ["Referer": Router.Biu_BaseAPI_Signup]
        case .GetFMData(_):
            return ["Referer": Router.Biu_BaseAPI_FM]
        case .GetLrc(_):
            return ["Referer": Router.Biu_BaseAPI_FM]
        default:
            return [:]
        }
    }
    
    var baseURLString: String {
        switch self {
        case .Login(_, _):
            return Router.Biu_BaseAPI_Android
        case .UpdateSelfInfo:
            return Router.Biu_BaseAPI_Android
        case .GetMyList:
            return Router.Biu_BaseAPI_Android
        case .GetNewList:
            return Router.Biu_BaseAPI_Android
        case .GetHotList:
            return Router.Biu_BaseAPI_Android
        case .GetSongTickets(_):
            return Router.Biu_BaseAPI_Android
        case .GetSongDetails(_):
            return Router.Biu_BaseAPI_Android
        case .GetSongsDetails(_):
            return Router.Biu_BaseAPI_Android
        case .GetLike:
            return Router.Biu_BaseAPI_Android
        case .AddLike(_):
            return Router.Biu_BaseAPI_Android
        case .DelLike(_):
            return Router.Biu_BaseAPI_Android
        case .Search(_):
            return Router.Biu_BaseAPI_Android
        case .GetFMData(_):
            return Router.Biu_BaseAPI_Web
        case .GetLrc(_):
            return Router.Biu_BaseAPI_Web
        case .Signup(_, _, _):
            return Router.Biu_BaseAPI_Web
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .Signup(_, _, _):
            return .post
        case .Login(_, _):
            return .post
        case .UpdateSelfInfo:
            return .post
        case .GetLike:
            return .post
        case .GetMyList:
            return .post
        case .GetNewList:
            return .post
        case .GetHotList:
            return .post
        case .GetSongTickets(_):
            return .post
        case .GetSongDetails(_):
            return .post
        case .GetSongsDetails(_):
            return .post
        case .AddLike(_):
            return .post
        case .Search(_):
            return .post
        case .DelLike(_):
            return .post
        case .GetFMData(_):
            return .get
        case .GetLrc(_):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .GetLike:
            return getConfig(withName: "GetLike", cat: "Route")
        case .UpdateSelfInfo:
            return getConfig(withName: "UpdateSelfInfo", cat: "Route")
        case .Login(_, _):
            return getConfig(withName: "Login", cat: "Route")
        case .GetMyList:
            return getConfig(withName: "GetMyList", cat: "Route")
        case .GetNewList:
            return getConfig(withName: "GetNewList", cat: "Route")
        case .GetHotList:
            return getConfig(withName: "GetHotList", cat: "Route")
        case .GetSongTickets(_):
            return getConfig(withName: "GetSongTickets", cat: "Route")
        case .GetSongDetails(_):
            return getConfig(withName: "GetSongDetails", cat: "Route")
        case .GetSongsDetails(_):
            return getConfig(withName: "GetSongDetails", cat: "Route")
        case .AddLike(_):
            return getConfig(withName: "AddLike", cat: "Route")
        case .DelLike(_):
            return getConfig(withName: "DelLike", cat: "Route")
        case .Search(_):
            return getConfig(withName: "Search", cat: "Route")
        case .GetFMData(_):
            return getConfig(withName: "GetFMData", cat: "Route")
        case .GetLrc(_):
            return getConfig(withName: "GetLrc", cat: "Route")
        case .Signup(_, _, _):
            return getConfig(withName: "Signup", cat: "Route")
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .Signup(let username, let password, let name):
            return [
                "email": username,
                "password": password,
                "password2": password,
                "name": name,
                "qq": "",
                "gender": "X"
            ]
        case .GetLike:
            return [
                "token": Variable.token ?? "",
                "lid": Variable.likecollect ?? ""
            ]
        case .UpdateSelfInfo:
            return [
                "token": Variable.token ?? "",
            ]
        case .Login(let username, let password):
            return [
                "email": username,
                "password": password
            ]
        case .GetMyList:
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? ""
            ]
        case .GetNewList:
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? ""
            ]
        case .GetHotList:
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? ""
            ]
        case .Search(let Query):
            return [
                "token": Variable.token ?? "",
                "uid": Variable.uid ?? "",
                "search": Query
            ]
        case .GetSongTickets(let Songid):
            return [
                "token": Variable.token ?? "",
                "sid": Songid
            ]
        case .GetSongDetails(let Songid):
            return [
                "token": Variable.token ?? "",
                "sid": Songid
            ]
        case .GetSongsDetails(let Songid):
            return [
                "token": Variable.token ?? "",
                "sid": String(Songid.joined(separator: ","))
            ]
        case .AddLike(let Songid):
            return [
                "token": Variable.token ?? "",
                "sid": Songid
            ]
        case .DelLike(let Songid):
            return [
                "token": Variable.token ?? "",
                "sid": Songid
            ]
        case .GetFMData(let Category):
            return [
                "datacenter": "0",
                "rid": String(Category),
                "_r": String(Double.random(in: 0...1))
            ]
        case .GetLrc(let Songid):
            return [
                "sid": Songid
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

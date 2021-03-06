//
//  LoginHelper.swift
//  Biu
//
//  Created by Akizuki Hiyako on 2020/03/01.
//  Copyright © 2020 Akizuki Hiyako. All rights reserved.
//

import Cache
import UIKit.UIImage
import SwiftUI
import Foundation
import SwiftyJSON
import Alamofire
import Kingfisher

final class LoginHelper : ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var password2 = ""
    @Published var name = ""
    @Published var qqNumber = ""
    @Published var answer = "..."
    @Published var signing = false
    @Published var webapi = false
    @Published private(set) var token = ""
    
    func login() {
        self.signing  = true
        Constants.session.request(Router.login(username: self.username, password: self.password))
            .validate().responseJSON { response in self.ticketHelper(response) }
    }
    
    func signup() {
        self.signing  = true
        if self.password != self.password2 {
            self.answer = "两次输入的密码不正确。"
            return
        }
        Constants.session.request(Router.signup(username: self.username, password: self.password, name: self.name))
            .validate().responseJSON { response in self.signHelper(response) }
    }
    
    func signHelper(_ response: AFDataResponse<Any>) {
        guard let object = response.data else {
            self.signing = false
            self.answer = "Request Error or System Error"
            return
        }
        let json = JSON(object)
        guard json["status"] == true else {
            self.signing = false
            self.answer = json["error"].string ?? "Decode Error"
            return
        }
        self.answer = "注册成功。正在登录..."
        Constants.session.request(Router.login(username: self.username, password: self.password))
            .validate().responseJSON { response in self.ticketHelper(response) }
    }
    
    func ticketHelper(_ response: AFDataResponse<Any>) {
        self.signing = false
        //        print(response.debugDescription)
        guard let object = response.data else {
            self.answer = "Request Error or System Error"
            return
        }
        let json = JSON(object)
        guard json["status"] == true else {
            self.answer = json["error"].string ?? "Decode Error"
            return
        }
        if let ticket = json["token"].string {
            Variable.token = ticket
            try? Variable.ticketstorage?.setObject(Data(ticket.utf8), forKey: "token", expiry: .never)
        }
        self.readCache()
        self.updateSelfIntro()
    }
    
    func updateSelfIntro() {
        Constants.session.request(Router.updateSelfInfo).validate().responseJSON { response in
            //            debugPrint(response.debugDescription)
            guard let object = response.data else {
                return
            }
            let json = JSON(object)
            guard json["status"].exists() else {
                return
            }
            guard json["status"] == true else {
                self.logout()
                return
            }
            for (key, subJson):(String, JSON) in json {
                switch key {
                case "email":
                    Variable.email = subJson.string ?? ""
                    try? Variable.ticketstorage?.setObject(Data(subJson.string!.utf8),
                                                           forKey: "email", expiry: .never)
                case "uid":
                    Variable.uid = subJson.string ?? ""
                    try? Variable.ticketstorage?.setObject(Data(subJson.string!.utf8),
                                                           forKey: "uid", expiry: .never)
                case "name":
                    Variable.name = subJson.string ?? ""
                    try? Variable.ticketstorage?.setObject(Data(subJson.string!.utf8),
                                                           forKey: "name", expiry: .never)
                case "like_collect":
                    Variable.likecollect = subJson.string ?? ""
                    try? Variable.ticketstorage?.setObject(Data(subJson.string!.utf8),
                                                           forKey: "likecollect", expiry: .never)
                default: break
                }
            }
        }
    }
    
    func readCache() {
        if let ticket = try? Variable.ticketstorage?.object(forKey: "token") {
            if String(data: ticket, encoding: .utf8) != nil {
                //                debugPrint(String(data: ticket, encoding: .utf8) as Any)
                self.answer = "登录成功"
                self.token = "ok"
            } else {
                debugPrint("bug:\(ticket)")
                self.token = ""
            }
        } else {
            debugPrint("bug: No Res")
            self.token = ""
        }
    }
    
    func logout() {
        try? Variable.ticketstorage?.removeAll()
        self.token = ""
        self.username = ""
        self.answer = "..."
        self.password = ""
    }
}

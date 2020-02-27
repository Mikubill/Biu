//
//  Utils.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation

func date2String(_ date: Date, dateFormat: String = "HH:mm") -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.string(from: date)
    return date
}

func getConfig(withName name: String, cat: String) -> String {
    let dictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Biu", ofType: "plist")!)
    let array = dictionary?[cat] as? NSDictionary
    //.xor(key: UInt8(7))!
    return array?[name] as? String ?? ""
}

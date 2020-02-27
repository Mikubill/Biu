//
//  InitatHome.swift
//  Biu
//
//  Created by Ayari on 2019/09/25.
//  Copyright © 2019 Ayari. All rights reserved.
//
import Cache
import UIKit.UIImage
import SwiftUI
import Foundation
import SwiftyJSON
import Alamofire
import Kingfisher

final class initAtHome: ObservableObject {
    
    func totalSize() throws -> UInt64 {
        var size: UInt64 = 0
        let filemanager = FileManager()
        let path = Variable.diskstorage?.path
        let contents = try filemanager.contentsOfDirectory(atPath: path!)
        for pathComponent in contents {
            let filePath = (path! as NSString).appendingPathComponent(pathComponent)
            let attributes = try filemanager.attributesOfItem(atPath: filePath)
            if let fileSize = attributes[.size] as? UInt64 {
                size += fileSize
            }
        }
        return size
    }
    
    func UpdateCacheSize() {
        
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                self.KFCache = "Disk Image Cache Size: \(String(format: "%.2f", (Double(size) / 1024 / 1024))) MB"
            case .failure(let error):
                print(error)
            }
        }
        
        if let size = try? self.totalSize() {
            self.CPCache = "Disk Songs Cache Size: \(String(format: "%.2f", (Double(size) / 1024 / 1024))) MB"
        }
        self.IsChanged.toggle()
    }
    
    func DataHandler(_ response: AFDataResponse<Any>) -> ([String], [Any]) {
        guard let object = response.data else {
            return ([], [])
        }
        let json = JSON(object)
        guard json["status"] == true else {
            return ([], [])
        }
        self.IsChanged.toggle()
        return pairs(json)
    }
    
    func GetJsonData() {
        
        self.IsChanged.toggle()
        
        // MARK: Get My List
        Constants.S.request(Router.GetMyList).validate().responseJSON() { response in (Variable.my_music_list_key, Variable.my_music_list_title) = self.DataHandler(response) as! ([String], [[String]]) }
        
        // MARK: Get Newest
        Constants.S.request(Router.GetNewList).validate().responseJSON() { response in (Variable
            .new_music_list_key, Variable.new_music_list_title) = self.DataHandler(response) as! ([String], [String]) }
        
        // MARK: Get Hottest
        Constants.S.request(Router.GetHotList).validate().responseJSON() { response in (Variable.hot_music_list_key, Variable.hot_music_list_title) = self.DataHandler(response) as! ([String], [String]) }
        
        UpdateCacheSize()
        
    }
    @Published var IsChanged = false
    @Published var KFCache = ""
    @Published var CPCache = ""
}

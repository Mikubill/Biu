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

class Initialization: ObservableObject {
    
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
    
    func updateCacheSize() {
        
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                self.kfCache = "Disk Image Cache Size: \(String(format: "%.2f", (Double(size) / 1024 / 1024))) MB"
            case .failure(let error):
                print(error)
            }
        }
        
        if let size = try? self.totalSize() {
            self.cpCache = "Disk Songs Cache Size: \(String(format: "%.2f", (Double(size) / 1024 / 1024))) MB"
        }
        self.isChanged.toggle()
    }
    
    func dataHandler(_ response: AFDataResponse<Any>) -> ([String], [Any]) {
        guard let object = response.data else {
            return ([], [])
        }
        let json = JSON(object)
        guard json["status"] == true else {
            return ([], [])
        }
        self.isChanged.toggle()
        return pairs(json)
    }
    
    func getJsonData() {
        
        self.isChanged.toggle()
        
        // MARK: Get My List
        Constants.session.request(Router.getMyList).validate().responseJSON { response in
            let data = self.dataHandler(response) as? ([String], [[String]])
            assert(data != nil)
            (Variable.myPlaylistKey, Variable.myPlaylistTitle) = data! }
        
        // MARK: Get Newest
        Constants.session.request(Router.getNewList).validate().responseJSON { response in
            let data = self.dataHandler(response) as? ([String], [Song])
            assert(data != nil)
            Variable.newMusicPlaylist = data!.1 }
        
        // MARK: Get Hottest
        Constants.session.request(Router.getHotList).validate().responseJSON { response in
            let data = self.dataHandler(response) as? ([String], [Song])
            assert(data != nil)
            Variable.hotMusicPlaylist = data!.1 }
        
        updateCacheSize()
        
    }
    @Published var isChanged = false
    @Published var kfCache = ""
    @Published var cpCache = ""
    
    
}

//
//  SearchWorker.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import Foundation
import SwiftyJSON
import Alamofire
import Kingfisher

final class SearchWorker: ObservableObject {

    @Published private(set) var start = false
    @Published private(set) var songs = [Song]()

    func search(query: String) {
        self.start = true
        Constants.session.request(Router.search(query: query))
            .validate().responseJSON { response in
                guard let object = response.data else {
                    return
                }
                let json = JSON(object)
                guard json["status"] == true else {
                    return
                }
                self.start = false
                self.songs = searchpairs(json["result"])
        }
    }

    func clearSongs() {
        self.songs = [Song]()
    }
}

//
//  GetCollectionDetails.swift
//  Biu
//
//  Created by Ayari on 2019/09/29.
//  Copyright © 2019 Ayari. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class CollectionDetails: ObservableObject {
    @Published var defaultPlaylist = [Song]()
    @Published var hlist = [Song]()
    func getdetails(_ index: [String], _ defaultMode: Bool) {
        debugPrint("Called")
        Constants.session.request(Router.getSongsDetails(songid: index))
            .validate().responseJSON { response in
                guard let object = response.data else {
                    return
                }
                let json = JSON(object)
                guard json["status"] == true else {
                    return
                }
                if defaultMode {
                    self.defaultPlaylist = jsonResultParser(json["result"])
                } else {
                    self.hlist = jsonResultParser(json["result"])
                }
        }
    }
}

//
//  CollectionListView.swift
//  Biu
//
//  Created by Ayari on 2019/09/29.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

import KingfisherSwiftUI

struct CollectionListView: View {
    
    @EnvironmentObject var state: AppState
    @EnvironmentObject var details: CollectionDetails
    @EnvironmentObject var playerstate: PlayerState
    @State var showlimit = 1
    
    let Page = 100
    
    var i : Int
    var title : [[String]]
    var body: some View {
        VStack {
            ScrollView(.vertical , showsIndicators: false) {
                VStack {
                    Button(action: { self.state.replaceMyCollection(self.i) }) {
                        Text("播放全部")
                            .font(Font.headline)
                    }
                    Divider()
                }
                .padding()
                if self.details.Playlist.count != 0 {
                    ForEach( 0...Int(self.details.Playlist.count / self.Page), id:\.self ) { index in
                        self.generageview(index)
                    }
                } else {
                    HStack {
                        ActivityIndicator(style: .large)
                            .frame(width: 35, height: 35)
                        Text("歌曲载入中...")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                BottomPadding()
            }
            .sheet(isPresented: $playerstate.PlayerIsOnIns) {
                PlayerView()
                .environmentObject(self.state)
                .environmentObject(self.playerstate)
            }
        }
        .navigationBarTitle(Text(Variable.my_music_list_key[self.i].prefix(40)), displayMode: .inline)
        .onAppear(){
            self.details.Playlist = [Song]()
            self.details.getdetails(self.title[self.i], true)
        }
    }
    
    func generageview(_ index: Int) -> CollectionListItem? {
        //debugPrint(index, self.showlimit)
        if (index < self.showlimit) {
            return CollectionListItem(index: index, last: false, limit: $showlimit)
        }
        if (index == self.showlimit) {
            let x = self.details.Playlist.count % self.Page
            let y = Int(self.details.Playlist.count / self.Page)
            if index < y - 1 {
                return CollectionListItem(index: index, last: true, limit: $showlimit)
            }
            if x > 0, index == y - 1 {
                return CollectionListItem(index: index, last: true, limit: $showlimit)
            }
            return CollectionListItem(index: index, last: false, limit: $showlimit)
        }
        return nil
    }
}

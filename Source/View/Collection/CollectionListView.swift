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

    let indicesPerPage = 100

    var collectionIndex: Int
    var title: [[String]]
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Button(action: { self.state.replaceMyCollection(self.collectionIndex) }) {
                        Text("播放全部")
                            .font(Font.headline)
                    }
                    Divider()
                }
                .padding()
                if self.details.defaultPlaylist.count != 0 {
                    ForEach( 0...Int(self.details.defaultPlaylist.count / self.indicesPerPage), id: \.self ) { index in
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
            .sheet(isPresented: $playerstate.playerIsOnIns) {
                PlayerView()
                .environmentObject(self.state)
                .environmentObject(self.playerstate)
            }
        }
        .navigationBarTitle(Text(Variable.myPlaylistKey[self.collectionIndex].prefix(40)), displayMode: .inline)
        .onAppear {
//            self.details.defaultPlaylist = [Song]()
            self.details.getdetails(self.title[self.collectionIndex], true)
        }
    }

    func generageview(_ index: Int) -> CollectionListItem? {
        //debugPrint(index, self.showlimit)
        if index < self.showlimit {
            return CollectionListItem(index: index, last: false, limit: $showlimit)
        }
        if index == self.showlimit {
            let indicesExceeded = self.details.defaultPlaylist.count % self.indicesPerPage
            let indicesPerPage = Int(self.details.defaultPlaylist.count / self.indicesPerPage)
            if index < indicesPerPage - 1 {
                return CollectionListItem(index: index, last: true, limit: $showlimit)
            }
            if indicesExceeded > 0, index == indicesPerPage - 1 {
                return CollectionListItem(index: index, last: true, limit: $showlimit)
            }
            return CollectionListItem(index: index, last: false, limit: $showlimit)
        }
        return nil
    }
}

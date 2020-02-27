//
//  PlayListView.swift
//  Biu
//
//  Created by Ayari on 2019/09/28.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

import KingfisherSwiftUI

struct PlayListView: View {
    
    @EnvironmentObject var state: AppState
    @EnvironmentObject var playerstate: PlayerState
    
    var body: some View {
        VStack {
            VStack {
                Text("Now Playing")
                    .font(Font.title)
                Divider()
            }
            .padding()
            ScrollView(.vertical , showsIndicators: false) {
                ForEach(self.range(), id: \.self) { index in
                    VStack(alignment: .leading) {
                        SongRow(index: index, song: self.state.Playlist[index], withAddButton: false, withStartResponse: false)
                    }
                    .frame(height: 60)
                }
            }
        }
    }
    
    func range() -> ClosedRange<Int> {
        let p = self.state.identifier
        if self.state.Playlist.count == 0 {
            return 0...0
        }
        if self.state.Playlist.count <= 200 {
            return 0...self.state.Playlist.count - 1
        }
        if p < 30 {
            return 0...p + 30
        } else {
            if p < self.state.Playlist.count - 31 {
                return p - 30...p + 30
            } else {
                return p - 30...self.state.Playlist.count - 1
            }
        }
    }
}

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
    }
}

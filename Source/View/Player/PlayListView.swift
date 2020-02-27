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
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(self.range(), id: \.self) { index in
                    VStack(alignment: .leading) {
                        SongRow(index: index, song: self.state.playlist[index], withAddButton: false, withStartResponse: false)
                    }
                    .frame(height: 60)
                }
            }
        }
    }

    func range() -> ClosedRange<Int> {
        let localIdentifier = self.state.identifier
        if self.state.playlist.count == 0 {
            return 0...0
        }
        if self.state.playlist.count <= 200 {
            return 0...self.state.playlist.count - 1
        }
        if localIdentifier < 30 {
            return 0...localIdentifier + 30
        } else {
            if localIdentifier < self.state.playlist.count - 31 {
                return localIdentifier - 30...localIdentifier + 30
            } else {
                return localIdentifier - 30...self.state.playlist.count - 1
            }
        }
    }
}

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
    }
}

//
//  LatestRow.swift
//  Biu
//
//  Created by Ayari on 2020/02/25.
//  Copyright © 2020 Ayari. All rights reserved.
//

import SwiftUI

struct SongRow: View {

    @EnvironmentObject var state: AppState
    @EnvironmentObject var playerstate: PlayerState
    @EnvironmentObject var details: CollectionDetails
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @State var selfpressed = false
    @State var pluspressed = false

    var index: Int
    var song: Song
    var withAddButton = true
    var withStartResponse = true
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                if self.state.nowPlaying?.id == song.id {
                    Image(systemName: "play")
                        .resizable()
                        .frame(width: 12, height: 14, alignment: .center)
                        .foregroundColor(.orange)
                } else {
                    Text("\(index)")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
            }
            .padding(.leading, 10)
            .frame(width: 45, height: 15)
            VStack(alignment: .leading) {
                if self.state.nowPlaying?.id == song.id {
                    Text(song.title)
                        .lineLimit(1)
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                        .padding(.bottom, 3)
                } else {
                    Text(song.title)
                        .lineLimit(1)
                        .font(.system(size: 16))
                        .padding(.bottom, 3)
                }

                Text("\(song.singer) - \(song.album)")
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            Spacer()
            if withAddButton {
                VStack {
                    Button(action: {
                        self.state.add(for: self.song)
                        self.pluspressed = true
                    }) {
                        Image(systemName: self.pluspressed ? "checkmark": "plus")
                            .resizable()
                    }
                    .frame(width: 12, height: 12, alignment: .center)
                    .disabled(self.pluspressed)
                }
                .padding(.trailing, 15)
            }

        }
        .frame(height: 50, alignment: .leading)
        .onTapGesture {
            print("Tapped: \(self.song)")
            if self.withStartResponse {
                self.state.start(for: self.song)
                self.selfpressed = true
            } else {
                self.state.set(self.index)
                //                self.playerstate.PlayListOneIsOn = false
            }

        }
    }
}

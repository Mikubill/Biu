//
//  CollectionListItem.swift
//  Biu
//
//  Created by Ayari on 2019/09/30.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CollectionListItem: View {

    @EnvironmentObject var details: CollectionDetails
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var vpressed = false

    var index: Int
    var last: Bool
    @Binding var limit: Int

    var body: some View {
        VStack {
            ForEach(0...calcd(), id: \.self) { index in
                SongRow(index: self.index * 100 + index + 1, song: self.song(index))
            }
            VStack {
                if self.last {
                    if !self.vpressed {
                        Text("点击载入更多")
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                            .onTapGesture {
                                print("Tapped")
                                self.limit += 1
                                self.vpressed = true
                        }
                        .disabled(self.vpressed)
                    }
                    if self.vpressed {
                        HStack {
                            ActivityIndicator(style: .large)
                                .frame(width: 35, height: 35)
                            Text("歌曲载入中...")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 5)
        }
    }

    func calcd() -> Int {
        let relativeIndex = self.details.defaultPlaylist.count - self.index * 100
        if relativeIndex > 100 {
            return 99
        } else {
            return relativeIndex - 1
        }
    }

    func song(_ index: Int) -> Song {
        let index = self.index * 100 + index
        return self.details.defaultPlaylist[index]
    }
}

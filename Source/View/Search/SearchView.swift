//
//  SearchView.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

import KingfisherSwiftUI

struct SearchView: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var worker: SearchWorker
    @EnvironmentObject var state: AppState
    @EnvironmentObject var playerstate: PlayerState
    @State var searchText: String = ""
    @State var showCancelButton: Bool = false
    @State var hideBarTitle: Bool = false
    @State private var showModel = false

    var body: some View {
        NavigationView {
            VStack {

                HStack {
                    SearchBar(text: $searchText, onSearchButtonClicked: fetch, onCancelButtonClicked: finish)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)

                ScrollView(.vertical, showsIndicators: false) {
                    if self.worker.start {
                        HStack {
                            ActivityIndicator(style: .large)
                                .frame(width: 35, height: 35)
                            Text("歌曲载入中...")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(Edge.Set.top, 20)
                    }
                    if !self.hideBarTitle {
                        LatestList()
                    }
                    if self.worker.songs.count > 0 {
                        ForEach(self.worker.songs.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
//                                SearchItem(index: index)
                                SongRow(index: index, song: self.worker.songs[index])
                            }
                            .onTapGesture {
                                print("Tapped")
                                self.state.start(for: self.worker.songs[index])
                            }
                        }
                    }

                }
                .navigationBarTitle(Text("Search"))
                .resignKeyboardOnDragGesture()

                BottomPadding()
            }
            .navigationBarHidden(self.hideBarTitle)
            .overlay(
                BlurView(style: self.colorScheme == .light ? .light : .dark)
                    .frame(width: 450, height: 70), alignment: .bottom)
                .overlay(
                    MiniPlayerView()
                        .onTapGesture {
                            self.showModel = true
                    }
                    .sheet(isPresented: self.$showModel) {
                        PlayerView()
                            .environmentObject(self.state)
                            .environmentObject(self.playerstate)
                    }, alignment: .bottom
            )
        }
    }

    private func finish() {
        UIApplication.shared.endEditing(true)
        self.hideBarTitle = false
        self.worker.clearSongs()
    }

    private func fetch() {
        UIApplication.shared.endEditing(true)
        self.hideBarTitle = true
        self.worker.search(query: searchText)
    }

}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged {_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

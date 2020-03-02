//
//  HomeSubView.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeSubView: View {
    
    @EnvironmentObject var inita: Initialization
    @EnvironmentObject var state: AppState
    @EnvironmentObject var details: CollectionDetails
    @EnvironmentObject var playerstate: PlayerState
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var update = false
    @State var showModel = false
    @State var downing = false
    @State var offset = -40
    
    @State private var activePageIndex: Int = 0
    
    let tileWidth: CGFloat = 220
    let tilePadding: CGFloat = 20
    let numberOfTiles: Int = 5
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        NavigationView {
            List {
                
                // MARK: - Hot Music
                VStack(alignment: .leading) {
                    
                    Text("最热歌曲")
                        .font(.headline)
                        .padding(Edge.Set.leading)
                        .padding(Edge.Set.top, 10)
                    
                    Text("抓取自全站播放数据")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(Edge.Set.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            ForEach(0..<7) { index in
                                VStack(alignment: .center, spacing: 20) {
                                    HomeViewStack(index: index)
                                }
                            }
                            Spacer()
                                .frame(width: 15)
                        }
                    }
                }
                .padding(Edge.Set.bottom)
                .listRowInsets(EdgeInsets())
                
                // MARK: - Radio
                
                VStack(alignment: .leading) {
                    Text("音乐电台")
                        .font(.headline)
                        .padding(Edge.Set.leading)
                        .padding(Edge.Set.top, 10)
                    
                    Text("选择困难症克星")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(Edge.Set.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            ForEach(1..<4, id: \.self) { index in
                                FMViewItem(fmGroupIndex: index)
                            }
                            FMViewItem(fmGroupIndex: 0)
                            Spacer()
                                .frame(width: 10)
                        }
                    }
                }
                .padding(Edge.Set.bottom)
                .listRowInsets(EdgeInsets())
                
                
                // MARK: - Radio
                
                VStack(alignment: .leading) {
                    Text("新歌入库")
                        .font(.headline)
                        .padding(Edge.Set.leading)
                        .padding(Edge.Set.top, 10)
                    
                    Text("快来看看有没有喜欢的")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(Edge.Set.leading)
                    
//                    LatestList()
//                        .padding()
                    
                    VStack {
                        if Variable.newMusicPlaylist.count == 0 {
                            HStack {
                                Text("Fetching Updates...")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                        } else {
                            ForEach(0..<Variable.newMusicPlaylist.count) { index in
                                SongRow(index: index, song: Variable.newMusicPlaylist[index], withAddButton: false)
                            }
                        }
                    }
                    .padding(.top)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                .padding(Edge.Set.bottom)
                .listRowInsets(EdgeInsets())
                
                
//                HomeListView()
//                    .padding()
//                    .listRowInsets(EdgeInsets())
                BottomPadding()
            }
            .navigationBarTitle(Text("Biu.Moe"))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .overlay(
            BlurView(style: colorScheme == .light ? .light : .dark)
                .frame(width: 450, height: 70), alignment: .bottom
        )
            .overlay(
                MiniPlayerView()
                    .onTapGesture {
                        //                        self.state.UpdateListInfo()
                        self.playerstate.playerIsOn = true
                }
                .sheet(isPresented: $playerstate.playerIsOn) {
                    PlayerView()
                        .environmentObject(self.state)
                        .environmentObject(self.playerstate)
                }, alignment: .bottom
        )
    }
    
}

struct HomeSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSubView()
    }
}

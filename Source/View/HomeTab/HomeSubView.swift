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
    
    @EnvironmentObject var inita: initAtHome
    @EnvironmentObject var state: AppState
    @EnvironmentObject var details: CollectionDetails
    @EnvironmentObject var playerstate: PlayerState
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var update = false
    @State var showModel = false
    @State var Downing = false
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
            List() {
                
                //MARK: - Hot Music
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Trending")
                        .bold()
                    ScrollView(.horizontal , showsIndicators: false) {
                        HStack{
                            ForEach(0..<7) { index in
                                VStack(alignment: .center, spacing: 20) {
                                    HomeViewStack(index: index, title:Variable.hot_music_list_title, key: Variable.hot_music_list_key)
                                }
                            }
                        }
                    }
                }
                
                
                
                //MARK: - Radio
                
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Radio")
                        .bold()
                    ScrollView(.horizontal , showsIndicators: false) {
                        HStack{
                            ForEach(1..<4, id: \.self) { i in
                                FMViewItem(i: i)
                            }
                            FMViewItem(i: 0)
                        }
                    }
                    Spacer()
                }
                
                HomeListView()
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                BottomPadding()
            }
                .navigationBarTitle(Text("Home"))
        }
            
        .frame(minWidth: 0, maxWidth: .infinity)
        .overlay(
            BlurView(style: colorScheme == .light ? .light : .dark)
                .frame(width: 450, height: 70)
            ,alignment: .bottom
        )
            .overlay(
                MiniPlayerView()
                    .onTapGesture {
//                        self.state.UpdateListInfo()
                        self.playerstate.PlayerIsOn = true
                }
                .sheet(isPresented: $playerstate.PlayerIsOn) {
                    PlayerView()
                        .environmentObject(self.state)
                        .environmentObject(self.playerstate)
                }
                ,alignment: .bottom
        )
    }
    
}

struct HomeSubView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSubView()
    }
}

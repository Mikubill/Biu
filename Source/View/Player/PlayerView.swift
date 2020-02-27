//
//  PlayerView.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

import KingfisherSwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var state: AppState
    @EnvironmentObject var playerstate: PlayerState
    
    var body: some View {
        VStack {
            
            VStack(alignment: .center) {
                if !self.state.FMisLoading {
                    Text(self.state.NowSong?.title ?? "Nothing")
                        .lineLimit(1)
                        .font(.title)
                        .padding(Edge.Set.top, 40)
                        .padding(Edge.Set.bottom, 20)
                    Text(self.state.NowSong?.singer ?? "Nothing")
                        .lineLimit(1)
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    Text("正在加载FM: \(FMViewItem.FMContents[self.state.fmmode])")
                        .font(.title)
                        .padding(Edge.Set.top, 40)
                        .padding(Edge.Set.bottom, 20)
                    Text("...")
                        .font(.headline)
                }
            }
                
            .padding()
            KFImage(URL(string: "\(Router.Biu_BaseAPI_Cover)/\(self.state.NowSong?.id ?? "0")")!)
                .resizable()
                .frame(width: 300, height: 300, alignment: .center)
                .cornerRadius(10)
                .scaledToFit()
                .clipped(antialiased: true)
                .shadow(radius: 10)
                .padding()
            VStack(alignment: .center) {
                Text("这里是设计用来放歌词的地方")
                    .font(.headline)
                Text("SubLryicLayer(w)")
                    .font(.headline)
                
            }
            .frame(width: 400, height: 150, alignment: .center)
            PlayerControls()
        }
    }
}

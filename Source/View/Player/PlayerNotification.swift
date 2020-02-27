//
//  PlayerNotification.swift
//  Biu
//
//  Created by Ayari on 2019/12/08.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct PlayerNotification: View {
    var SongName: String
    var body: some View {
        HStack{
            Image(systemName: "play.circle")
                .resizable()
                .font(Font.title.weight(.ultraLight))
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30, alignment: .center)
            Text("\(SongName) 已添加到播放列表")
        }
    }
}

struct PlayerNotification_Previews: PreviewProvider {
    static var previews: some View {
        PlayerNotification(SongName: "Test Song")
    }
}

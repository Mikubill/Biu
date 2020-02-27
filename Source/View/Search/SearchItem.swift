//
//  SearchItem.swift
//  Biu
//
//  Created by Ayari on 2019/09/30.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SearchItem: View {
    @EnvironmentObject var state: AppState
    @EnvironmentObject var worker: SearchWorker
    @State var pluspressed = false
    //    @EnvironmentObject var inita: initAtHome
    //    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var index: Int
    var body: some View {
        HStack {
            
            VStack(alignment: .center) {
                Text("\(self.index)")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
            }
            .padding(.leading, 10)
            .frame(width: 45)
            VStack(alignment: .leading) {
                Text(self.worker.songs[self.index].title)
                    .lineLimit(1)
                    .font(.system(size: 16))
                    .padding(.bottom, 3)
                Text("\(self.worker.songs[self.index].singer) - \(self.worker.songs[self.index].album)")
                    .lineLimit(1)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            Spacer()
            VStack {
                Button(action: {
                    self.state.add(for: self.worker.songs[self.index])
                    self.pluspressed = true
                }) {
                    Image(systemName: self.pluspressed ? "checkmark": "plus")
                        .frame(width: 30, height: 30, alignment: .center)
                }
                .disabled(self.pluspressed)
                .padding(.trailing, 10)
            }
        }
    }
}

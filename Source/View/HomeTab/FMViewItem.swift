//
//  FMViewItem.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct FMViewItem: View {

    @EnvironmentObject var state: AppState
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var fmGroupIndex: Int
    static let FMContents = ["全部随机", "动画", "Galgame", "偶像", "东方Project", "VOCALOID", "同人", "纯音乐"]

    var body: some View {
        VStack {
            ForEach(0..<2) { index in
                Button(action: {
                    if !self.state.radioIsLoading {
                        self.state.FMON(self.fmGroupIndex * 2 + index)
                    }
                }) {
                    VStack {
                        ImageView(imageURL: "\(Router.biuBaseAPIFMCover)/\(self.fmGroupIndex * 2 + index).jpg", width: 200, height: 80)
                        Text(String(FMViewItem.FMContents[self.fmGroupIndex * 2 + index]))
                            .font(.footnote)
                            .lineLimit(nil)
                            .foregroundColor(self.colorScheme == .light ? .black : .white)

                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(height: 110)
            }
        }
    }
}

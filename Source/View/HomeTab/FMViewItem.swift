//
//  FMViewItem.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct FMViewItem: View {
    
    @EnvironmentObject var state: AppState
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var i: Int
    static let FMContents = ["全部随机", "动画", "Galgame", "偶像", "东方Project", "VOCALOID", "同人", "纯音乐"]
    
    var body: some View {
        VStack{
            ForEach(0..<2) { index in
                Button(action: {
                    if !self.state.FMisLoading {
                        self.state.FMON(self.i * 2 + index)
                    }
                }) {
                    VStack{
                        KFImage(URL(string: "\(Router.Biu_BaseAPI_FMCover)/\(self.i * 2 + index).jpg")!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 200, height: 80, alignment: .center)
                            .cornerRadius(5)
                            .shadow(radius: 5)
                            .scaledToFit()
                        
                        Text(String(FMViewItem.FMContents[self.i * 2 + index]))
                            .font(Font.subheadline)
                            .lineLimit(nil)
                            .foregroundColor(self.colorScheme == .light ? .black : .white)
                        
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

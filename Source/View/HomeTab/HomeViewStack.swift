//
//  HomeViewStack.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import UIKit
import KingfisherSwiftUI

struct HomeViewStack: View {
    @EnvironmentObject var state: AppState
    @EnvironmentObject var inita: initAtHome
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var index: Int
    var title: [String]
    var key: [String]
    
    var body: some View {
        VStack {
            ForEach(0..<2) { i in
                VStack {
                    if self.title != [] {
                        Button(action: {
                            debugPrint("Tapped Hot_Stack_\(self.index)")
                            self.state.isLoading = true
                            self.state.start(for: Song(id: self.title[self.index * 2 + i], title: self.key[self.index * 2 + i], singer: "", album: ""))
                        }){
                            KFImage(URL(string: "\(Router.Biu_BaseAPI_Cover)/\(self.title[self.index * 2 + i])")!)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .cornerRadius(5)
                                .shadow(radius: 5)
                                .scaledToFit()
                            
                            Text(String(self.key[self.index * 2 + i]))
                                .font(Font.subheadline)
                                .lineLimit(1)
                                .foregroundColor(self.colorScheme == .light ? .black : .white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        // MARK - Check Local Cache
                        Image(uiImage: UIColor.gray.image() )
                            .resizable()
                            .shadow(radius: 5)
                            .frame(width: 100, height: 100, alignment: .center)
                            .cornerRadius(5)
                        //                            .animation(.easeInOut)
                        Text("Loading..")
                            .font(Font.subheadline)
                            .foregroundColor(self.colorScheme == .light ? .black : .white)
                    }
                }
                .frame(width: 110, height: 140)
            }
        }
        
    }
}

//
//  HomeViewStack.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeViewStack: View {
    @EnvironmentObject var state: AppState
    @EnvironmentObject var inita: Initialization
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var index: Int

    var body: some View {
        VStack {
            ForEach(0..<2) { index in
                VStack {
                    if Variable.hotMusicPlaylist.count != 0 {
                        Button(action: {
                            debugPrint("Tapped Hot_Stack_\(self.index * 2 + index)")
                            self.state.isLoading = true
                            self.state.start(for: Variable.hotMusicPlaylist[self.index * 2 + index])
                        }) {
                            ImageView(imageURL: "\(Router.biuBaseAPICover)/\(Variable.hotMusicPlaylist[self.index * 2 + index].id)", width: 100, height: 100)
                            Text(Variable.hotMusicPlaylist[self.index * 2 + index].title)
                                .font(.footnote)
                                .lineLimit(1)
                                .foregroundColor(self.colorScheme == .light ? .black : .white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        // MARK: - Check Local Cache
                        Image(uiImage: UIColor.gray.image() )
                            .resizable()
                            .shadow(radius: 5)
                            .frame(width: 100, height: 100, alignment: .center)
                            .cornerRadius(5)
                        //                            .animation(.easeInOut)
                        Text("Loading..")
                            .font(.footnote)
                            .foregroundColor(self.colorScheme == .light ? .black : .white)
                    }
                }
                .frame(width: 110, height: 140)
            }
        }

    }
}

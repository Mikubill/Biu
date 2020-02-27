//
//  CollectionView.swift
//  Biu
//
//  Created by Ayari on 2019/09/28.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CollectionView: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var collection: Int
    var title: [[String]]
    var key: [String]

    var body: some View {
        VStack {
            if self.key != [] {
                NavigationLink(destination: CollectionListView(collectionIndex: self.collection, title: self.title)) {
                    HStack {
                        KFImage(URL(string: "\(Router.biuBaseAPICover)/\(self.getFirstid(self.collection))")!)
                            .renderingMode(.original)
                            .resizable()
                            .cornerRadius(5)
                            .shadow(radius: 5)
                            .frame(width: 50, height: 50, alignment: .leading)
                            .scaledToFit()

                        VStack(alignment: .leading) {
                            Text(Variable.myPlaylistKey[self.collection])
                                .lineLimit(1)
                                .font(.system(size: 20))
                                .padding(Edge.Set.bottom, 5)
                            Text("Songs: \(self.title[self.collection].count)")
                                .lineLimit(1)
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding(Edge.Set.leading, 5)
                        .foregroundColor(self.colorScheme == .light ? .black : .white)
                    }
                }
            } else {
                if self.collection != 0 {
                    HStack {
                        Image(uiImage: UIColor.gray.image() )
                            .resizable()
                            .shadow(radius: 5)
                            .frame(width: 50, height: 50, alignment: .leading)
                            .opacity(0.5)

                        VStack(alignment: .leading) {
                            HStack {
                                Text("载入资料中...")
                                    .font(.system(size: 20))
                                    .padding(Edge.Set.bottom, 5)
                                Spacer()

                            }

                        }
                        .padding(Edge.Set.leading, 5)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                    }
                }
            }
        }
    }

    func backgroundDetector() -> Color {
        if self.colorScheme == .light {
            return Color.white
        } else {
            return Color.black
        }
    }

    func getFirstid(_ playlist: Int) -> String {
        if Variable.myPlaylistTitle[playlist].count > 0 {
            return Variable.myPlaylistTitle[playlist][0]
        } else {
            return "0"
        }
    }
}

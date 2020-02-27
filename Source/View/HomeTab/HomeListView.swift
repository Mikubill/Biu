//
//  HomeListView.swift
//  Biu
//
//  Created by Ayari on 2019/12/09.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct HomeListView: View {
    @EnvironmentObject var inita: Initialization

    var body: some View {
        ForEach(Variable.myPlaylistTitle.indices, id: \.self) { index in
            CollectionView(collection: index, title: Variable.myPlaylistTitle, key: Variable.myPlaylistKey)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}

//
//  HomeListView.swift
//  Biu
//
//  Created by Ayari on 2019/12/09.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct HomeListView: View {
    @EnvironmentObject var inita: initAtHome
    
    var body: some View {
        ForEach(Variable.my_music_list_title.indices, id:\.self) { i in
            CollectionView(i: i, title:Variable.my_music_list_title, key: Variable.my_music_list_key)
            .padding(.leading, 10)
            .padding(.trailing, 10)
        }
    }
}

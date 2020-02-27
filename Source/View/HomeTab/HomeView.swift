//
//  HomeView.swift
//  Biu
//
//  Created by Ayari on 2019/09/25.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        UIKitTabView([
            UIKitTabView.Tab(view: HomeSubView(), title: "Home", image: "location", selectedImage: "location.fill"),
            UIKitTabView.Tab(view: SearchView(), title: "Search", image: "magnifyingglass"),
            UIKitTabView.Tab(view: SettingsView(), title: "Settings", image: "gear")
        ])
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

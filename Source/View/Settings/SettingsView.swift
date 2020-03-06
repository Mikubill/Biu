//
//  SettingsView.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {

                NavView(title: "Setting")
                    .padding()

                VStack {
                    UserProfile()
                    UserInterface()
                    CacheManager()
                    CacheControl()
                    About()
                    Logout()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(5)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))

        }
    }
}

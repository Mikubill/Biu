//
//  SettingsView.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
//    @Environment(\.colorScheme) var colorScheme: ColorScheme
//    @EnvironmentObject var inita: initAtHome
//    @EnvironmentObject var worker: SearchWorker
//    @EnvironmentObject var state: AppState
//    @EnvironmentObject var playerstate: PlayerState
//    @EnvironmentObject var loginhelper: LoginHelper
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical , showsIndicators: false) {
                
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
                    .padding()
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

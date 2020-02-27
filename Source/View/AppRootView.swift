//
//  AppRootView.swift
//  Biu
//
//  Created by Ayari on 2019/09/30.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct AppRootView: View {

    @ObservedObject var loginhelper : LoginHelper
    var body: some View {
        Group {
            if self.loginhelper.token != "" {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

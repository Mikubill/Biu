//
//  Logout.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct Logout: View {
    @EnvironmentObject var state: AppState
    @EnvironmentObject var loginhelper: LoginHelper
    @State private var showingSheet = false
    
    var body: some View {
        VStack(alignment: .center) {
            
            Button(action: {
                self.showingSheet = true
            }) {
                Text("Logout")
                    .frame(width:200, alignment: .center)
            }
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("确定要登出吗？"), message: Text("这将会删除所有个人数据（包括缓存数据）"), buttons: [
                    .destructive(
                        Text("确定")
                    ){
                        self.state.player.stop()
                        Constants.imageCache.clearMemoryCache()
                        Constants.imageCache.clearDiskCache()
                        Variable.ticketstorage?.async.removeAll() { _ in print("Done.") }
                        Variable.storage?.async.removeAll() { _ in print("Done.") }
                        self.loginhelper.logout()
                    },
                    .cancel() {
                        self.showingSheet = false
                    }
                ])
            }
        }
        .padding()
    }
}

struct Logout_Previews: PreviewProvider {
    static var previews: some View {
        Logout()
    }
}

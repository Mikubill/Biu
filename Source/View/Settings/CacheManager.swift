//
//  CacheManager.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct CacheManager: View {
    
    @EnvironmentObject var state: AppState
    
    @State private var showGreetingc = true
    @State private var showGreetingd = true
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("缓存管理设置")
                .font(Font.headline)
            
            Divider()
            
            Toggle(isOn: $showGreetingc) {
                Text("缓存自动管理")
            }
            .padding()
            .disabled(true)
            
            Toggle(isOn: $showGreetingd) {
                Text("边听边存")
            }
            .padding()
            .disabled(self.showGreetingc)
            
            Toggle(isOn: $state.CacheRadio) {
                Text("缓存电台音乐")
            }
            .padding()
            .disabled(self.showGreetingc)
            
        }
        .padding()
    }
}

struct CacheManager_Previews: PreviewProvider {
    static var previews: some View {
        CacheManager()
    }
}

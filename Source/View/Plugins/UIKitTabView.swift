//
//  UIKitTabView.swift
//  Biu
//
//  Created by Ayari on 2019/10/04.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct UIKitTabView: View {
    var viewControllers: [UIHostingController<AnyView>]
    @State var selectedIndex: Int = 0
    
    init(_ views: [Tab]) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
    }
    
    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        // convenience
        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
            let selectedImage = selectedImage != nil ? UIImage(systemName: selectedImage!, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular )) : nil
            let noselectedImage = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .regular ))
            let barItem = UITabBarItem(title: title, image: noselectedImage, selectedImage: selectedImage)
            self.init(view: view, barItem: barItem)
        }
    }
}

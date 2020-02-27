//
//  UpdateButtonView.swift
//  Biu
//
//  Created by Ayari on 2019/10/04.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct UpdateButtonView: View {
    @State var update = false
    @EnvironmentObject var inita: Initialization

    var body: some View {
        Button(action: {
            self.update = true
            self.inita.getJsonData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.update = false
            }
        }) {
            if self.update {
                ActivityIndicator(style: .medium)
            }
            Text("更新")
        }
        .edgesIgnoringSafeArea(Edge.Set.top)
        .edgesIgnoringSafeArea(Edge.Set.bottom)
        .padding(Edge.Set.trailing, 5)
    }
}

struct UpdateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateButtonView()
    }
}

//
//  NavView.swift
//  Biu
//
//  Created by Ayari on 2019/12/09.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct NavView: View {
    var title: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Biu > \(title)")
                .font(Font.title)
            HStack {
                Text("\(String((Variable.name ?? "").prefix(20)))")
                    .font(.subheadline)
                Spacer()
            }
        }
        .padding(Edge.Set.leading, 20)
        .padding(Edge.Set.trailing, 20)
        .padding(Edge.Set.top, 10)
        .padding(Edge.Set.bottom, -10)
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView(title: "")
    }
}

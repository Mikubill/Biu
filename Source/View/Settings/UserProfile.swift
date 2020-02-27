//
//  UserProfile.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct UserProfile: View {
    var body: some View {
        HStack {
            KFImage(URL(string: "\(Router.biuBaseAPIAvatar)/\(Variable.uid ?? "0")")!)
                .resizable()
                .cornerRadius(5)
                .shadow(radius: 5)
                .frame(width: 70, height: 70, alignment: .center)
                .animation(.easeInOut)
            .padding(Edge.Set.leading, 10)
            VStack(alignment: .leading) {
                Text("\(Variable.name ?? "nil")".prefix(40))
                    .font(.headline)
                Text("Email: \(Variable.email ?? "nil")".prefix(40))
                    .font(.subheadline)
                Text("ID: \(Variable.uid ?? "nil")".prefix(40))
                    .font(.subheadline)
            }
            .padding(Edge.Set.leading, 20)
            .frame(width: 250, alignment: .leading)
        }
        .padding()
        .padding(Edge.Set.leading, 10)
        .padding(Edge.Set.top, 15)
        .padding(Edge.Set.bottom, 15)
        .frame(width: 400, alignment: .leading)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}

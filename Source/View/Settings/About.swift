//
//  About.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct About: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(Font.headline)
            Divider()

            Text("\(Constants.httpVia) By Ayari")
                .padding()
            VStack(alignment: .leading, spacing: 10) {
                Text("Dependencies:")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Text("Alamofire/Alamofire 5.0.2")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Text("onevcat/Kingfisher 5.13.1")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Text("SwiftyJSON/SwiftyJSON 5.0.0")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Text("hyperoslo/Cache 5.2.0")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding()
        }
        .padding()
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}

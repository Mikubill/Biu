//
//  ImageView.swift
//  Biu
//
//  Created by Akizuki Hiyako on 2020/02/29.
//  Copyright © 2020 Akizuki Hiyako. All rights reserved.
//

import SwiftUI
import UIKit
import struct Kingfisher.DownsamplingImageProcessor
import struct Kingfisher.RoundCornerImageProcessor
import class Kingfisher.ImageCache
import KingfisherSwiftUI

struct ImageView: View {
    var imageURL: String = "https://web.biu.moe/Public/Lcover/0/4860.jpeg"
    var width: CGFloat = 150
    var height: CGFloat = 150
    var alignment: Alignment = .center
    
    @State var done = false
    var alreadyCached: Bool {
        ImageCache.default.isCached(forKey: self.imageURL)
    }
    
    var body: some View {
        KFImage(
            URL(string: imageURL),
            options: [
                .transition(.fade(0.2)),
                .processor(DownsamplingImageProcessor(size: CGSize(width: self.width, height: self.height))),
                .processor(RoundCornerImageProcessor(cornerRadius: 10)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
        ])
            .onSuccess { r in
                self.done = true
                print("Success: \(self.imageURL) - \(r.cacheType)")
            }
            .onFailure { e in
                print("Error \(self.imageURL): \(e)")
            }
            .placeholder {
                Image(uiImage: UIImage(named: "biu")!)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.3)
                    .frame(width: width, height: height, alignment: alignment)
                    .foregroundColor(.gray)
                    .animation(.easeInOut)
        }
        .renderingMode(.original)
        .cancelOnDisappear(true)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .scaledToFit()
        .frame(width: width, height: height, alignment: .center)
        .opacity(done || alreadyCached ? 1.0 : 0.3)
        .animation(.linear(duration: 0.4))
        .cornerRadius(5)
        .shadow(radius: 5)
//        .renderingMode(.original)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
        .clipShape(Circle())
    }
}

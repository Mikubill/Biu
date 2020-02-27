//
//  BottomPadding.swift
//  Biu
//
//  Created by Ayari on 2019/12/09.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct BottomPadding: View {
    var body: some View {
        Divider()
            .opacity(0)
            .padding(Edge.Set.bottom, 70)
    }
}

struct BottomPadding_Previews: PreviewProvider {
    static var previews: some View {
        BottomPadding()
    }
}

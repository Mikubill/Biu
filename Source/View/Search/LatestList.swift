//
//  LatestList.swift
//  Biu
//
//  Created by Ayari on 2020/02/25.
//  Copyright © 2020 Ayari. All rights reserved.
//

import SwiftUI

struct LatestList: View {
    
    @EnvironmentObject var details: CollectionDetails
    
    var body: some View {
        VStack{
            HStack{
                Text("Latest Uploaded")
                    .bold()
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding()
            if self.details.Hlist.count == 0 {
                HStack {
                    Text("Fetching Updates...")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                ForEach(0..<Variable.new_music_list_title.count) { index in
                    SongRow(index: index, song: self.details.Hlist[index])
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .onAppear(){
            self.details.Hlist = [Song]()
            self.details.getdetails(Variable.new_music_list_title, false)
        }
    }
}

struct LatestList_Previews: PreviewProvider {
    static var previews: some View {
        LatestList()
    }
}

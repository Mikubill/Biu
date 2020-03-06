//
//  CacheControl.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct CacheControl: View {

    @EnvironmentObject var inita: Initialization
    @EnvironmentObject var state: AppState

    @State private var musicCleanedA = false
    @State private var musicCleanedB = false

    @State private var imgCleanedA = false
    @State private var imgCleanedB = false

    @State private var cleanyesa = false
    @State private var cleanyesb = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Cache Control")
                .font(Font.headline)

            Divider()

            VStack {
                HStack {
                    Text("更新缓存大小数据")
                        .frame(alignment: .leading)
                    Button(action: {
                        self.inita.updateCacheSize()
                    }) {
                        Text("更新")
                            .frame(alignment: .trailing)
                    }
                }
            }
            .padding()
            .padding(Edge.Set.bottom, 30)

            VStack {
                Text("\(self.inita.cpCache)")
            }
            .padding()

            VStack {
                HStack {
                    Text("清理过期音乐缓存")
                        .frame(alignment: .leading)
                    Button(action: {
                        Variable.storage?.async.removeExpiredObjects { result in
                            switch result {
                            case .value:
                                print("removal completes")
                            case .error(let error):
                                print(error)
                            }
                            self.musicCleanedA = true
                        }
                    }) {
                        Text("清理")
                            .frame(alignment: .trailing)
                    }
                    .disabled(self.musicCleanedA)

                }

            }
            .padding()

            VStack {
                HStack {
                    Text("清理所有音乐缓存")
                        .frame(alignment: .leading)
                    Button(action: {
                        self.cleanyesa = true
                    }) {
                        Text("清理")
                            .frame(alignment: .trailing)
                    }
                    .disabled(self.musicCleanedB)
                    .actionSheet(isPresented: $cleanyesa) {
                        ActionSheet(title: Text("确定要清理吗？"), message: Text("这将会删除所有音乐缓存"), buttons: [
                            .destructive(
                                Text("确定")
                            ) {
                                Variable.storage?.async.removeAll { result in
                                    switch result {
                                    case .value:
                                        print("removal completes")
                                    case .error(let error):
                                        print(error)
                                    }
                                    self.musicCleanedB = true
                                }
                            },
                            .cancel() {
                                self.cleanyesa = false
                            }
                        ])
                    }
                }
            }
            .padding()
            .padding(Edge.Set.bottom, 30)

            VStack {
                Text("\(self.inita.kfCache)")
            }
            .padding()

            VStack {
                HStack {
                    Text("清理过期画像缓存")
                        .frame(alignment: .leading)
                    Button(action: {
                        Constants.imageCache.cleanExpiredMemoryCache()
                        Constants.imageCache.cleanExpiredDiskCache {
                            print("Done")
                            self.imgCleanedB = true
                        }
                    }) {
                        Text("清理")
                            .frame(alignment: .trailing)
                    }
                    .disabled(self.imgCleanedB)
                }
            }
            .padding()

            VStack {
                HStack {
                    Text("清理所有画像缓存")
                        .frame(alignment: .leading)
                    Button(action: {
                        self.cleanyesb = true

                    }) {
                        Text("清理")
                            .frame(alignment: .trailing)
                    }
                    .disabled(self.imgCleanedA)
                    .actionSheet(isPresented: $cleanyesb) {
                        ActionSheet(title: Text("确定要清理吗？"), message: Text("这将会删除所有画像缓存"), buttons: [
                            .destructive(
                                Text("确定")
                            ) {
                                Constants.imageCache.clearMemoryCache()
                                Constants.imageCache.clearDiskCache {
                                    print("Done")
                                    self.imgCleanedA = true
                                }
                            },
                            .cancel() {
                                self.cleanyesb = false
                            }
                        ])
                    }
                }
            }
            .padding()

        }
        .padding()
    }
}

struct CacheControl_Previews: PreviewProvider {
    static var previews: some View {
        CacheControl()
    }
}

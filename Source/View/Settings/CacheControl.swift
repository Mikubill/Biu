//
//  CacheControl.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct CacheControl: View {
    
    @EnvironmentObject var inita: initAtHome
    @EnvironmentObject var state: AppState
    
    @State private var MusicCleanedA = false
    @State private var MusicCleanedB = false
    
    @State private var IMGCleanedA = false
    @State private var IMGCleanedB = false
    
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
                        .frame(width: 270, alignment: .leading)
                    Button(action: {
                        self.inita.UpdateCacheSize()
                    }) {
                        Text("更新")
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
            .padding()
            .padding(Edge.Set.bottom, 30)
            
            VStack {
                Text("\(self.inita.CPCache)")
            }
            .padding()
            
            VStack {
                HStack {
                    Text("清理过期音乐缓存")
                        .frame(width: 270, alignment: .leading)
                    Button(action: {
                        Variable.storage?.async.removeExpiredObjects() { result in
                            switch result {
                            case .value:
                                print("removal completes")
                            case .error(let error):
                                print(error)
                            }
                            self.MusicCleanedA = true
                        }
                    }) {
                        Text("清理")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .disabled(self.MusicCleanedA)
                    
                }
                
            }
            .padding()
            
            VStack {
                HStack {
                    Text("清理所有音乐缓存")
                        .frame(width: 270, alignment: .leading)
                    Button(action: {
                        self.cleanyesa = true
                    }) {
                        Text("清理")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .disabled(self.MusicCleanedB)
                    .actionSheet(isPresented: $cleanyesa) {
                        ActionSheet(title: Text("确定要清理吗？"), message: Text("这将会删除所有音乐缓存"), buttons: [
                            .destructive(
                                Text("确定")
                            ){
                                Variable.storage?.async.removeAll() { result in
                                    switch result {
                                    case .value:
                                        print("removal completes")
                                    case .error(let error):
                                        print(error)
                                    }
                                    self.MusicCleanedB = true
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
                Text("\(self.inita.KFCache)")
            }
            .padding()
            
            VStack {
                HStack {
                    Text("清理过期画像缓存")
                        .frame(width: 270, alignment: .leading)
                    Button(action: {
                        Constants.imageCache.cleanExpiredMemoryCache()
                        Constants.imageCache.cleanExpiredDiskCache {
                            print("Done")
                            self.IMGCleanedB = true
                        }
                    }) {
                        Text("清理")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .disabled(self.IMGCleanedB)
                }
            }
            .padding()
            
            VStack {
                HStack {
                    Text("清理所有画像缓存")
                        .frame(width: 270, alignment: .leading)
                    Button(action: {
                        self.cleanyesb = true
                        
                    }) {
                        Text("清理")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .disabled(self.IMGCleanedA)
                    .actionSheet(isPresented: $cleanyesb) {
                        ActionSheet(title: Text("确定要清理吗？"), message: Text("这将会删除所有画像缓存"), buttons: [
                            .destructive(
                                Text("确定")
                            ){
                                Constants.imageCache.clearMemoryCache()
                                Constants.imageCache.clearDiskCache {
                                    print("Done")
                                    self.IMGCleanedA = true
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

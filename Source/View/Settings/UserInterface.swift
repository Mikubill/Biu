//
//  Interface.swift
//  Biu
//
//  Created by Ayari on 2019/10/02.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct UserInterface: View {
    
    @EnvironmentObject var state: AppState
    @State private var showGreetinga = true
    @State private var shuffle = false
    @State private var timerstate = false
    @State private var timerstatet = false
    @State private var showingSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("用户界面设置")
                .font(Font.headline)
            
            Divider()
            
            Toggle(isOn: $showGreetinga) {
                Text("Auto Drak Mode")
            }.padding()
                .disabled(true)
            
            Toggle(isOn: $state.RandomPlay) {
                Text("随机歌单歌曲")
            }
            .padding()
            .disabled(false)
            HStack {
                Text("立即shuffle歌单")
                    .frame(width: 270, alignment: .leading)
                Button(action: {
                    //                                self.shuffle = true
                    self.state.shuffle()
                }) {
                    Text("更新")
                        .frame(width: 50, alignment: .trailing)
                }
                //                            .disabled(self.shuffle)
            }
            .padding()
            
            Toggle(isOn: $timerstate) {
                Text("定时关闭")
            }
            .padding()
            .disabled(false)
            
            if self.timerstate {
                HStack {
                    Text("关闭时间设置： ")
                    
                    Button(action: {
                        self.showingSheet = true
                    }) {
                        Text("\(self.getsleepstate())")
                    }
                    .actionSheet(isPresented: $showingSheet) {
                        ActionSheet(title: Text("定时关闭"), message: Text("选择关闭时间（暂不支持自定义）"), buttons: [
                            .default(Text("120分钟后")) {self.state.sleep(120)},
                            .default(Text("60分钟后")) {self.state.sleep(60)},
                            .default(Text("30分钟后")) {self.state.sleep(30)},
                            .default(Text("20分钟后")) {self.state.sleep(20)},
                            .default(Text("取消定时器")) {self.state.cancelsleep()},
                            .cancel() {self.showingSheet = false}
                        ])
                    }
                    .disabled(false)
                }
                .padding()
            }

        }
        .padding()
    }
    func getsleepstate() -> String {
        if Variable.timer == nil {
            return "未设置"
        } else {
            return date2String(Variable.timeDate!)
        }
    }
}

//
//  PlayerControls.swift
//  Biu
//
//  Created by Ayari on 2019/09/26.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI
import Combine

struct PlayerControls: View {

    @EnvironmentObject var state: AppState
    @EnvironmentObject var playerstate: PlayerState
    @State var duration: Double = 0
    @State var timestamp: ((String, String), (String, String)) = (("00", "00"), ("00", "00"))

    var body: some View {
        VStack {
            VStack {
                Spacer()

                Slider(value: $duration, in: 0...1, onEditingChanged: {
                    debugPrint($0, self.duration)
                    self.endTimer()
                    self.state.userModified($0, dest: self.duration)
                    self.startTimer()
                })
                    .frame(idealWidth: 350.0, idealHeight: 40)
                    .disabled(self.state.isLoading)
                

                HStack {
                    Text("\(self.timestamp.0.0):\(self.timestamp.0.1)")
                    Spacer()
                    Text("\(self.timestamp.1.0):\(self.timestamp.1.1)")
                }
                .frame(idealWidth: 350, alignment: .center)
            }
            .padding(25) //?
            Spacer()
            HStack(spacing: 25) {

                // MARK: buttons
                if !self.state.isLikeing {
                    if self.state.nowPlaying != nil {
                        if !(self.state.nowPlaying?.like ?? false) {
                            Button(action: { self.state.addlike(self.state.nowPlaying?.id ?? "1") }) {
                                Image(systemName: "heart")
                                    .resizable()
                                    .font(Font.title.weight(.thin))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                        } else {
                            Button(action: { self.state.dellike(self.state.nowPlaying?.id ?? "1") }) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .font(Font.title.weight(.thin))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                        }
                    } else {
                        if self.state.playlist.count == 0 {
                            Button(action: { self.state.addlike(self.state.nowPlaying?.id ?? "1") }) {
                                Image(systemName: "heart")
                                    .resizable()
                                    .font(Font.title.weight(.thin))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                            .disabled(true)
                        } else {
                            ActivityIndicator(style: .large)
                                .frame(width: 25, height: 25)
                        }
                    }
                } else {
                    ActivityIndicator(style: .large)
                        .frame(width: 25, height: 25)
                }

                Button(action: {
                    self.state.isLoading = true
                    self.state.pull()
                }) {
                    Image(systemName: "backward.end")
                        .resizable()
                        .font(Font.title.weight(.thin))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .disabled(self.state.playlist.count == 0)
                if !self.state.isLoading {
                    Button(action: {
                        self.state.playingtoggle()
                    }) {
                        Image(systemName: self.state.isPlaying ? "pause.circle" : "play.circle")
                            .resizable()
                            .font(Font.title.weight(.ultraLight))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .disabled(self.state.playlist.count == 0)
                    }
                } else {
                    ActivityIndicator(style: .large)
                        .frame(width: 70, height: 70)
                }
                Button(action: {
                    self.state.isLoading = true
                    self.state.push()
                }) {
                    Image(systemName: "forward.end")
                        .resizable()
                        .font(Font.title.weight(.thin))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .disabled(self.state.playlist.count == 0)

                Button(action: {
                    self.playerstate.playListOneIsOn = true
                    self.state.updateListInfo()
                }) {
                    Image(systemName: "list.dash")
                        .resizable()
                        .font(Font.title.weight(.thin))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .disabled(self.state.radioIsOn)
                .disabled(self.state.playlist.count == 0)

            }
            .padding(Edge.Set.bottom, 20)
            Spacer()
        }
        .sheet(isPresented: $playerstate.playListOneIsOn) {
            PlayListView()
            .environmentObject(self.state)
            .environmentObject(self.playerstate)
        }
        .onAppear {
            self.duration = self.state.during
            self.timestamp = self.state.timestamp
            self.startTimer()
        }
        .onDisappear {
            self.endTimer()
        }
    }

    func startTimer() {
        Variable.ntimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
            self.duration = self.state.during
            self.timestamp = self.state.timestamp
        }
    }

    func endTimer() {
        Variable.ntimer?.invalidate()
    }
}

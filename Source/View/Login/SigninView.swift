//
//  SigninView.swift
//  Biu
//
//  Created by Ayari on 2019/09/29.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct SigninView: View {

    @EnvironmentObject var loginhelper: LoginHelper
    @State var sec = false

    var body: some View {

        VStack {

            Text("Biu iOS Client")
                .font(.largeTitle)
                .padding(Edge.Set.top, 20)
            .padding(Edge.Set.bottom, 50)

            if !sec {
                Text("USERNAME")
                    .font(.headline)
                .padding(10)
                TextField("Email", text: $loginhelper.username)
                    .textContentType(.emailAddress)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 3)
                )
                .padding(20)
                HStack {
                    Button(action: {
                        self.sec = true
                    }) {Text("Go")
                        .font(.title)
                    }.padding(20)
                }
            }

            if sec {
                Text("PASSWORD")
                    .font(.headline)

                SecureField("PASSWORD", text: $loginhelper.password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 3)
                )
                .padding(10)
                Toggle(isOn: $loginhelper.webapi) {
                    Text("接受 Biu 使用条款")
                }
                .disabled(self.loginhelper.answer == "正在请求数据...")
                .padding(10)
                HStack {
                    Button(action: {
                        self.loginhelper.answer = "正在请求数据..."
                        self.loginhelper.login()
                    }) {Text("Login")
                        .font(.title)
                    }.padding(20)
                        .disabled(!self.loginhelper.webapi)

                    Button(action: {
                        self.loginhelper.answer = "..."
                        self.loginhelper.username = ""
                        self.loginhelper.password = ""
                        self.sec = false
                    }) {Text("Return")
                        .font(.title)
                    }.padding(20)
                }
                Text(self.loginhelper.answer)
                    .font(.headline)
                .padding(10)
            }

        }
        .frame(height: 600, alignment: .top)
        .padding(Edge.Set.leading, 20)
        .padding(Edge.Set.trailing, 40)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }

    }

}

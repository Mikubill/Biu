//
//  LoginView.swift
//  Biu
//
//  Created by Ayari on 2019/09/28.
//  Copyright © 2019 Ayari. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var inita: Initialization
    @State var showbutton = true
    @State var showreg = false
    @EnvironmentObject var loginhelper: LoginHelper
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var strengths = ["汉子", "妹子", "秀吉"]
    @State private var selectedStrength = 0
    
    var body: some View {
        VStack {
            if !self.showreg {
                if self.colorScheme == .light {
                    Image(uiImage: UIImage(named: "trans-black")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
                    .padding(Edge.Set.top, 40)
                    .padding(Edge.Set.bottom, 25)
                    .padding(10)
                } else {
                    Image(uiImage: UIImage(named: "trans-white")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150, alignment: .center)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
                    .padding(Edge.Set.top, 40)
                    .padding(Edge.Set.bottom, 25)
                    .padding(10)
                }
            }
            VStack {
                
                TextField("Email", text: $loginhelper.username)
                    .textContentType(.emailAddress)
                    .padding()
                    .overlay(
                        Rectangle()
                            .frame(height: 1.5, alignment: .bottom)
                            .foregroundColor(Color.gray), alignment: .bottom)
                    .padding(10)
                
                if self.showreg {
                    SecureField("Password", text: $loginhelper.password)
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 1.5, alignment: .bottom)
                                .foregroundColor(Color.gray), alignment: .bottom)
                        .padding(10)
                    
                    SecureField("Repeat Password", text: $loginhelper.password2)
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 1.5, alignment: .bottom)
                                .foregroundColor(Color.gray), alignment: .bottom)
                        .padding(10)
                    
                    TextField("Name", text: $loginhelper.name)
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 1.5, alignment: .bottom)
                                .foregroundColor(Color.gray), alignment: .bottom)
                        .padding(10)
                        .padding(Edge.Set.bottom, 20)
                } else {
                    SecureField("Password", text: $loginhelper.password, onCommit: commit)
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 1.0, alignment: .bottom)
                                .foregroundColor(Color.gray), alignment: .bottom)
                        .padding(10)
                        .padding(Edge.Set.bottom, 30)
                }
                
                Button(action: {
                    self.commit()
                }) {
                    if self.loginhelper.answer == "正在请求数据..." {
                        ActivityIndicator(style: .large)
                            .frame(width: 55, height: 55)
                    } else {
                        Image(systemName: "arrow.right.circle")
//                            .renderingMode(.original)
                            .resizable()
                            .font(Font.title.weight(.ultraLight))
                            .foregroundColor(self.colorScheme == .light ? .black : .white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                    }
                }
                .disabled(self.loginhelper.signing)
                
                Spacer()
                    .frame(width: 15, alignment: .center)
                
                Button(action: {
                    
                    withAnimation(.easeInOut(duration: 0.5)) { self.showreg.toggle() } }) {
                        if self.showreg {
                            Text("Return to Login")
                        } else {
                            Text("Sign up")
                        }
                }
                .disabled(self.loginhelper.signing)
                
                Text(self.loginhelper.answer)
                    .font(.headline)
                    .padding()
                
            }
        }
        .onDisappear(){
            self.inita.getJsonData()
        }
        .padding(20)
        .gesture(
            DragGesture()
                .onChanged({ (_) in
                    UIApplication.shared.endEditing()
                })
        )
        //        .sheet(isPresented: $signin) {
        //            SigninView()
        //                .environmentObject(self.loginhelper)
        //        }
    }
    
    
    func commit() {
        UIApplication.shared.endEditing()
        self.loginhelper.answer = "正在请求数据..."
        if self.showreg {
            self.loginhelper.signup()
        } else {
            self.loginhelper.login()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

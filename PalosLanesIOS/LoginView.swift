//
//  ContentView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/6/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var remember: Bool = false
    var body: some View {
        NavigationView {
           VStack {
                Image("logoheader")
                    .resizable()
                    .scaledToFit()
                TextField("Enter username", text:$username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal,.top])
                TextField("Enter password",text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .bottom])
                HStack {
                    Toggle(isOn: $remember) {
                        Text("Remember Me").fontWeight(.thin)
                    }.padding(.leading)
                    NavigationLink(destination: HomeView()) {
                        Text("Login").foregroundColor(.black)
                    }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                        .background(Color(red: 200/255, green: 200/255, blue: 200/255, opacity: 1.0))
                        .cornerRadius(8)
                        .padding([.trailing])
                    }.frame(minWidth: 0, maxWidth: .infinity)
                NavigationLink(destination: ForgotPassView()) {
                    Text("FORGOT PASSWORD?")
            }.padding()
                Spacer()
                Text("Don't have an account with us?")
                NavigationLink(destination: RegistrationVIew()) {
                    Text("REGISTER HERE").fontWeight(.semibold)
                }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                    .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                    .cornerRadius(10)
                    .padding([.horizontal, .bottom])
            }.background(Image("approach")
                .resizable()
                .clipped()
                .edgesIgnoringSafeArea(.all))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

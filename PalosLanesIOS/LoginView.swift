//
//  ContentView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/6/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import Combine


struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var remember: Bool = false
    @State var authenticated: Bool = false
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationView {
           VStack {
                Text("")
                    .navigationBarTitle("LOGIN")
                    .navigationBarItems(trailing:
                        Button(action: {
                            let formattedString = "https://chicagolandbowlingservice.com/privacy-policy"
                            let url = URL(string: formattedString)!
                            UIApplication.shared.open(url)
                        }){
                            Text("Privacy Policy")
                    })
            
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
                        Button(action: {
                            self.LoginRequest(username: self.username, password: self.password)
                        }) {
                            Text("Login").foregroundColor(.black)
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                            .background(Color(red: 200/255, green: 200/255, blue: 200/255, opacity: 1.0))
                            .cornerRadius(8)
                            .padding([.trailing])
                        }.frame(minWidth: 0, maxWidth: .infinity)
                    }
            
                NavigationLink(destination: HomeView(), isActive: $authenticated) {
                    Text("")
                }.hidden()
            
                NavigationLink(destination: ForgotPassView()) {
                    Text("FORGOT PASSWORD?")
                    }.padding()

                Spacer()
            
                Text("Don't have an account with us?")
                NavigationLink(destination: RegistrationVIew()) {
                    Text("REGISTER HERE").fontWeight(.semibold)
                    }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                     .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                     .cornerRadius(8)
                     .padding([.horizontal, .bottom])
            
            }.background(Image("approach")
                .resizable()
                .clipped()
                .edgesIgnoringSafeArea(.all))
        }
    }

func LoginRequest(username: String, password: String) {
    
    guard let url = URL(string: "https://chicagolandbowlingservice.com/api/Login") else {return}
          
          let body: [String: String] = ["Username": username, "Password": password]
          
          let finalbody = try! JSONSerialization.data(withJSONObject: body)
          
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.httpBody = finalbody
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          
          URLSession.shared.dataTask(with: request) { (data, response, error) in
              
              if let httpResponse = response as? HTTPURLResponse{
                  if httpResponse.statusCode == 200{
                      DispatchQueue.main.async {
                        self.authenticated.toggle()
                      }
                      return
                  }
                  if httpResponse.statusCode == 400{
                  print("Bad Request")
                  return
                  }
              }
              
          }.resume()
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

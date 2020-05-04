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
    @State var username: String = UserDefaults.standard.string(forKey: "SaveUsername") ?? ""
    @State var password: String = UserDefaults.standard.string(forKey: "SavePassword") ?? ""
    @State var remember: Bool = true
    @State var user: Bool = false
    @State var admin: Bool = false
    @State private var showingAlert = false
    @State var message: String = ""
    
    
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
                            if (self.username.count < 3) {
                                self.message = "Username must be atleast 3 characters"
                                self.showingAlert = true
                            }
                            else if (self.password.count < 6) {
                                self.message = "Password must be atleast 6 characters"
                                self.showingAlert = true
                            }
                            else {
                            self.LoginRequest(username: self.username, password: self.password)
                            if self.remember {
                                SaveData(username: self.username, password: self.password)
                                }
                            }
                        }) {
                            Text("Login").foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                            .background(Color(red: 200/255, green: 200/255, blue: 200/255, opacity: 1.0))
                            .cornerRadius(8)
                            .padding([.trailing])
                        }.frame(minWidth: 0, maxWidth: .infinity)
                    }
            
                ZStack {
                    NavigationLink(destination: HomeView(), isActive: $user) {
                        Text("")
                        }.hidden()
                
                    NavigationLink(destination: AdminView(), isActive: $admin) {
                        Text("")
                        }.hidden()
                }.hidden()
            
                NavigationLink(destination: ForgotPassView()) {
                    Text("FORGOT PASSWORD?")
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    }.padding()

                Spacer()
            
                Text("Don't have an account with us?")
                NavigationLink(destination: RegistrationVIew()) {
                    Text("REGISTER HERE").fontWeight(.semibold)
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                     .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                     .cornerRadius(8)
                     .padding([.horizontal, .bottom])
            
            }.background(Image("approach")
                .resizable()
                .clipped()
                .edgesIgnoringSafeArea(.all))
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Login Failed"), message: Text((message)), dismissButton: .default(Text("OK")))
                }
        }.onAppear {
            self.CheckToken()
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
                    
                    guard let data = data else {return}
                    let finalData = try! JSONDecoder().decode(LoginMessage.self, from: data)
                    
                    UserDefaults.standard.set(finalData.AccessLevel, forKey: "AccessLevel")
                    UserDefaults.standard.set(finalData.AuthToken, forKey: "AuthToken")
                      DispatchQueue.main.async {
                        if finalData.AccessLevel == "User" {
                            let AuthToken: String = UserDefaults.standard.string(forKey: "AuthToken") ?? ""
                            self.GetUserData(AuthToken: AuthToken)
                        }
                        else if finalData.AccessLevel == "Admin" {
                            self.admin.toggle()
                        }
                    }
                    return
                  }
                  if httpResponse.statusCode == 400{
                    DispatchQueue.main.async {
                        if let data = data, let dataString = String(data: data, encoding: .utf8) {
                            self.message = dataString
                            self.showingAlert = true
                        }
                    }
                    return
                }
                if httpResponse.statusCode == 500{
                    DispatchQueue.main.async {
                        self.message = "Oops something went wrong... please try again later"
                        self.showingAlert = true
                    }
                }
            }
        }.resume()
    }

    
func VerifyToken(AuthToken: String) {
    
    guard let url = URL(string: "https://chicagolandbowlingservice.com/api/Authenticate") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AuthToken, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    DispatchQueue.main.async {
                        if UserDefaults.standard.string(forKey: "AccessLevel") == "User" {
                            self.GetUserData(AuthToken: AuthToken)
                        }
                        else if UserDefaults.standard.string(forKey: "AccessLevel") == "Admin" {
                            self.admin.toggle()
                        }
                        else {
                            self.message = "Oops something went wrong... Please login again"
                            self.showingAlert = true
                        }
                    }
                    return
                }
                if httpResponse.statusCode == 401{
                    DispatchQueue.main.async {
                        self.message = "Session has expired... Please login again"
                        self.showingAlert = true
                        }
                    return
                }
                if httpResponse.statusCode == 500{
                    DispatchQueue.main.async {
                        self.message = "Oops something went wrong... please try again later"
                        self.showingAlert = true
                        }
                    return
                }
            }
        }.resume()
    }
    
    
    func GetUserData(AuthToken: String) {
    
    guard let url = URL(string: "https://chicagolandbowlingservice.com/api/Users") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AuthToken, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    
                    guard let data = data else {return}
                    let finalData = try! JSONDecoder().decode(DataMessage.self, from: data)
                    UserDefaults.standard.set(finalData.Points, forKey: "SavePoints")
                    UserDefaults.standard.set(finalData.Username, forKey: "SaveUsername")
                    UserDefaults.standard.set(finalData.Birthdate, forKey: "SaveBirthdate")
                    UserDefaults.standard.set(finalData.Email, forKey: "SaveEmail")
                    UserDefaults.standard.set(finalData.Fname, forKey: "SaveFirst")
                    UserDefaults.standard.set(finalData.Lname, forKey: "SaveLast")
                    UserDefaults.standard.set(finalData.Phone, forKey: "SavePhone")
                    UserDefaults.standard.set(finalData.Type, forKey: "SaveType")
                    UserDefaults.standard.set(finalData.League, forKey: "SaveLeague")
                    DispatchQueue.main.async {
                        self.user.toggle()
                    }
                    return
                }
                if httpResponse.statusCode == 401{
                    DispatchQueue.main.async {
                        self.message = "Session has expired... please login again"
                        self.showingAlert = true
                        }
                    return
                }
                if httpResponse.statusCode == 404{
                    DispatchQueue.main.async {
                        self.message = "User data was not found...please try again"
                        self.showingAlert = true
                        }
                    return
                }
                if httpResponse.statusCode == 500{
                    DispatchQueue.main.async {
                        self.message = "Oops something went wrong... please try again later"
                        self.showingAlert = true
                        }
                    return
                }
            }
        }.resume()
    }
    
    
func CheckToken() {
       if UserDefaults.standard.string(forKey: "AuthToken") != nil {
        let AuthToken: String = UserDefaults.standard.string(forKey: "AuthToken") ?? ""
        VerifyToken(AuthToken: AuthToken)
        }
    }
}

func SaveData(username: String, password: String) {
    UserDefaults.standard.set(username, forKey: "SaveUsername")
    UserDefaults.standard.set(password, forKey: "SavePassword")
}

struct LoginMessage: Decodable {
    let AuthToken, AccessLevel: String
}

struct DataMessage: Decodable {
    let Birthdate, Phone, Username, Email, Fname, Lname, `Type`: String
    let Points: Int
    let League: Bool
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

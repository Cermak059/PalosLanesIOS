//
//  RegistrationVIew.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/7/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct RegistrationVIew: View {
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var birthdate: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var league: Bool = false
    @State var username: String = ""
    @State var password: String = ""
    @State var conpass: String = ""
    @State private var showingAlert = false
    @State var message: String = ""
    var body: some View {
        ScrollView {
                VStack {
                    Image("logoheader")
                        .resizable()
                        .scaledToFit()
                       Spacer()
                    HStack {
                        VStack(alignment: .leading){
                            Text("First Name:").padding(.top, 22)
                            Text("Last Name:").padding(.top, 22)
                            Text("Birthdate:").padding(.top, 24)
                            Text("Email:").padding(.top, 24)
                            Text("Phone:").padding(.top, 24)
                            Spacer()
                        }.padding(.leading, 10)
                        VStack {
                            TextField("Enter first name", text:$firstname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding([.trailing,.top])
                            TextField("Enter last name", text:$lastname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.trailing)
                            TextField("Ex. 03/29/1993", text:$birthdate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.trailing)
                            TextField("Ex. bowling123@yahoo.com", text:$email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.trailing)
                            TextField("Ex. 708-123-1234", text:$phone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.trailing)
                        }
                    }
                    Toggle(isOn:$league) {
                        Text("Are you a current league memeber")
                    }.padding()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Username:")
                            Text("Password:").padding(.top, 22)
                            Text("Confirm:").padding(.top, 22)
                        }.padding(.leading, 10)
                        VStack {
                            TextField("Enter desired username", text:$username)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.trailing)
                            TextField("Enter password", text:$password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.trailing)
                            TextField("Re-type password", text:$conpass)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding([.trailing, .bottom])
                        }
                    }
                    Button(action: {
                        
                        if (self.firstname.count < 2 || self.lastname.count < 2) {
                            self.message = "First and last name must be more than 2 characters"
                            self.showingAlert = true
                        }
                        else if(self.birthdate.count != 10) {
                            self.message = "Birthdate must use format (00/00/0000)"
                            self.showingAlert = true
                        }
                        else if(self.email.count == 0) {
                            self.message = "Email field cannot be empty"
                            self.showingAlert = true
                        }
                        else if(self.phone.count != 12) {
                            self.message = "Phone number must use format (123-123-1234)"
                            self.showingAlert = true
                        }
                        else if(self.username.count < 3 || self.username.count > 12 ) {
                            self.message = "Username must be between 3 and 12 characters"
                            self.showingAlert = true
                        }
                        else if(self.password.count < 6 || self.password.count > 12) {
                            self.message = "Password must be between 6 and 12 characters"
                            self.showingAlert = true
                        }
                        else {
                            if self.league {
                                self.league = true
                            }
                            self.RegistrationRequest(username: self.username, password: self.conpass, fname: self.firstname, lname: self.lastname, birthday: self.birthdate, email: self.email, phone: self.phone, league: self.league)
                            }
                    }) {
                        Text("SUBMIT")
                    }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                        .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                        .cornerRadius(10)
                        .padding([.horizontal, .top])
                }
        }.background(Image("approach")
            .resizable()
            .clipped()
            .edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration"), message: Text((message)), dismissButton: .default(Text("OK")))
            }
        }
    
    func RegistrationRequest(username: String, password: String, fname: String, lname: String, birthday: String, email: String, phone: String, league: Bool) {
    
        guard let url = URL(string: "https://chicagolandbowlingservice.com/api/Register") else {return}
          
        let body: [String: Any] = ["Fname": fname, "Lname":lname, "Birthdate": birthday, "Email" : email, "Phone": phone, "League": league, "Username": username, "Password": password]
          
          let finalbody = try! JSONSerialization.data(withJSONObject: body)
          
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.httpBody = finalbody
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          
          URLSession.shared.dataTask(with: request) { (data, response, error) in
              
              if let httpResponse = response as? HTTPURLResponse{
                  if httpResponse.statusCode == 200{
                    
                    //guard let data = data else {return}
                    //let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                    DispatchQueue.main.async {
                        self.message = "Please check your email for verification"
                        self.showingAlert = true
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
                        self.message = "Oops something went wrong... please try again"
                        self.showingAlert = true
                    }
                }
            }
        }.resume()
    }
}

struct RegistrationVIew_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationVIew()
    }
}

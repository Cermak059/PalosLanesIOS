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
    let CenterID: String = "PalosLanes"
    
    var validation = Validation()
    
    var body: some View {
        VStack{
            Text("").navigationBarTitle("REGISTRATION").navigationBarHidden(false)
                ScrollView {
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
                                SecureField("Enter password", text:$password)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.trailing)
                                SecureField("Re-type password", text:$conpass)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding([.trailing, .bottom])
                            }
                        }
                        Button(action: {
                            
                            let isValidateName = self.validation.validateName(name: self.firstname)
                            let isValidateLastName = self.validation.validateLastName(name: self.lastname)
                            let isValidateBirthdate = self.validation.validateBirthdate(name: self.birthdate)
                            let isValidatePhone = self.validation.validatePhone(name: self.phone)
                            let isValidateUsername = self.validation.validateUsername(name: self.username)
                            let isValidatePassword = self.validation.validatePassword(name: self.password)
                            
                            if (isValidateName == false) {
                               self.message = "First name must be between 2 and 12 alphabetical characters"
                               self.showingAlert = true
                            }
                            else if (isValidateLastName == false) {
                                self.message = "Last name must be between 2 and 12 alphabetical characters"
                                self.showingAlert = true
                            }
                            else if (isValidateBirthdate == false) {
                                self.message = "Birthdate format must be 00/00/0000"
                                self.showingAlert = true
                            }
                            else if (self.email.count == 0) {
                                self.message = "Email field cannot be empty"
                                self.showingAlert = true
                            }
                            else if (isValidatePhone == false) {
                                self.message = "Phone number format must be 000-000-0000"
                                self.showingAlert = true
                            }
                            else if (self.username.count < 3 || self.username.count > 12) {
                                self.message = "Username must be between 3 and 12 characters"
                                self.showingAlert = true
                            }
                            else if (isValidateUsername == false) {
                                self.message = "Username must not have special characters"
                                self.showingAlert = true
                            }
                            else if (self.password.count < 6 || self.password.count > 12) {
                                self.message = "Password must be between 6 and 12 characters"
                                self.showingAlert = true
                            }
                            else if (isValidatePassword == false) {
                                self.message = "Password must not use special characters"
                                self.showingAlert = true
                            }
                            else if (self.password != self.conpass) {
                                self.message = "Passwords do not match"
                                self.showingAlert = true
                            }
                            else {
                                self.RegistrationRequest(username: self.username, password: self.conpass, fname: self.firstname, lname: self.lastname, birthday: self.birthdate, email: self.email, phone: self.phone, league: self.league, centerID: self.CenterID)
                                }
                        }) {
                            Text("SUBMIT")
                        }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                            .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                            .cornerRadius(10)
                            .padding()
                    }
            }.modifier(AdaptsToKeyboard())
            .background(Image("approach")
            .resizable()
            .clipped()
            .edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration"), message: Text((message)), dismissButton: .default(Text("OK")))
        }
    }
    
    func RegistrationRequest(username: String, password: String, fname: String, lname: String, birthday: String, email: String, phone: String, league: Bool, centerID: String) {
    
        guard let url = URL(string: "http://3.15.199.174:5000/Register") else {return}
          
        let body: [String: Any] = ["Fname": fname, "Lname":lname, "Birthdate": birthday, "Email" : email, "Phone": phone, "League": league, "Username": username, "Password": password, "CenterID": centerID]
          
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

class Validation {
public func validateName(name: String) ->Bool {
   // Length be 18 characters max and 3 characters minimum, you can always modify.
   let nameRegex = "^[A-Za-z]{2,12}$"
   let trimmedString = name.trimmingCharacters(in: .whitespaces)
   let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
   let isValidateName = validateName.evaluate(with: trimmedString)
   return isValidateName
    }
public func validateLastName(name: String) ->Bool {
    // Length be 18 characters max and 3 characters minimum, you can always modify.
    let nameRegex = "^[A-Za-z]{2,12}$"
    let trimmedString = name.trimmingCharacters(in: .whitespaces)
    let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    let isValidateName = validateName.evaluate(with: trimmedString)
    return isValidateName
    }
public func validateBirthdate(name: String) ->Bool {
    // Length be 18 characters max and 3 characters minimum, you can always modify.
    let nameRegex = "^[0-9]{2}/[0-9]{2}/[0-9]{4}$"
    let trimmedString = name.trimmingCharacters(in: .whitespaces)
    let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    let isValidateName = validateName.evaluate(with: trimmedString)
    return isValidateName
     }
public func validatePhone(name: String) ->Bool {
    // format must be 000-000-0000 and only numerical characters
    let nameRegex = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$"
    let trimmedString = name.trimmingCharacters(in: .whitespaces)
    let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    let isValidateName = validateName.evaluate(with: trimmedString)
    return isValidateName
     }
public func validateUsername(name: String) ->Bool {
    // format is no special characters
    let nameRegex = "^[A-Za-z0-9]{3,12}$"
    let trimmedString = name.trimmingCharacters(in: .whitespaces)
    let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    let isValidateName = validateName.evaluate(with: trimmedString)
    return isValidateName
     }
public func validatePassword(name: String) ->Bool {
    // format is no special characters
    let nameRegex = "^[A-Za-z0-9]{6,12}$"
    let trimmedString = name.trimmingCharacters(in: .whitespaces)
    let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    let isValidateName = validateName.evaluate(with: trimmedString)
    return isValidateName
     }
}

struct RegistrationVIew_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationVIew()
    }
}

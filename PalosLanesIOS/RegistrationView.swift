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
                        print("Button tapped")
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
        }
}

struct RegistrationVIew_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationVIew()
    }
}

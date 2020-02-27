//
//  ForgotPassView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/7/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct ForgotPassView: View {
    @State var forgotPass: String = ""
    @State var message: String = ""
    @State private var showingAlert = false
    var body: some View {
        VStack(alignment: .leading) {
            Image("logoheader")
                .resizable()
                .scaledToFit()
            Text("Password Reset")
                .padding([.leading,.top])
                .font(.title)
            TextField("Ex. bowling123@yahoo.com", text:$forgotPass)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Spacer()
            Button(action: {
                if (self.forgotPass.isEmpty) {
                    self.message = "Field cannot be empty"
                    self.showingAlert = true
                }
                else {
                    self.PasswordRequest(email: self.forgotPass)
                }
            }) {
                Text("SEND EMAIL")
            }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                .cornerRadius(10)
                .padding([.horizontal, .top])
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Password Reset"), message: Text((message)), dismissButton: .default(Text("OK")))
                }
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
    
    func PasswordRequest(email: String) {
    
    guard let url = URL(string: "https://chicagolandbowlingservice.com/api/ResetRequest") else {return}
          
        let body: [String: String] = ["Email": email]
          
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
                        self.message = "Please check email to continue password reset"
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
                if httpResponse.statusCode == 404{
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
}

struct ForgotPassView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassView()
    }
}

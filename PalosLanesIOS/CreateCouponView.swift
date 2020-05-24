//
//  CreateCouponView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 5/6/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct CreateCouponView: View {
    @State var couponName: String = ""
    var body: some View {
        VStack {
           Image("logoheader")
           .resizable()
           .scaledToFit()
            VStack(alignment: .leading){
                Text("Coupon Name:")
                    .padding([.horizontal,.top])
                TextField("Limited Time Only", text:$couponName)
                    .disabled(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                    .padding(.horizontal)
                Text("Expires In (Hours):")
                    .padding([.horizontal, .top])
                DropDown()
                Spacer()
                CreateButton()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
}
struct DropDown: View {
@State var expand: Bool = false
@State var dropDown: String = "24 Hours"
@State var Hours: Int = 24
var body: some View {
    VStack(alignment: .leading) {
        VStack(spacing: 30) {
            HStack {
                Text(dropDown)
                    .foregroundColor(.black)
                Image(systemName: expand ? "chevron.up":"chevron.down")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 13, height: 6)
                }.frame(height:30)
                .onTapGesture {
                    self.expand.toggle()
                }
                if expand {
                    Button(action: {
                        self.dropDown = "24 Hours"
                        self.Hours = 24
                        self.expand.toggle()
                    }) {
                        Text("24 Hours")
                    }
                    Button(action: {
                        self.dropDown = "48 Hours"
                        self.Hours = 48
                        self.expand.toggle()
                    }) {
                        Text("48 Hours")
                            .padding()
                            .foregroundColor(.black)
                    }
                    Button(action: {
                        self.dropDown = "72 Hours"
                        self.Hours = 72
                        self.expand.toggle()
                    }) {
                        Text("72 Hours")
                            .padding([.horizontal,.bottom])
                            .foregroundColor(.black)
                    }
                    Button(action: {
                        self.dropDown = "96 Hours"
                        self.Hours = 96
                        self.expand.toggle()
                    }) {
                        Text("96 Hours")
                            .padding([.horizontal,.bottom])
                            .foregroundColor(.black)
                    }
                    Button(action: {
                        self.dropDown = "120 Hours"
                        self.Hours = 120
                        self.expand.toggle()
                    }) {
                        Text("120 Hours")
                            .padding([.horizontal,.bottom])
                            .foregroundColor(.black)
                    }
                }
            }.padding(.horizontal)
            .background(Color(.white))
            .cornerRadius(7)
            .shadow(color: .gray, radius: 6)
        }.padding(.horizontal)
    }
}
struct CreateButton: View {
    @State var AuthToken: String = (UserDefaults.standard.string(forKey: "AuthToken") ?? nil) ?? ""
    var body: some View {
        VStack {
            Button(action: {
                self.CreateCoupon(CenterID: <#T##String#>, Hours: <#T##Int#>, CouponName: <#T##String#>)
                }) {
                    Text("Create")
                }
               .frame(minWidth: 0, maxWidth:  .infinity, maxHeight: 40)
               .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
               .cornerRadius(10)
               .padding()
        }
    }
    func CreateCoupon(CenterID: String, Hours: Int, CouponName: String) {
            
           guard let url = URL(string: "http://3.15.199.174:5000/CreateCoupon") else {return}
              
           let body: [String:Any] = ["CenterID": CenterID, "Hours": Hours, "CouponName": CouponName]
                  
               let finalbody = try! JSONSerialization.data(withJSONObject: body)
                  
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.httpBody = finalbody
               request.setValue(AuthToken, forHTTPHeaderField: "X-Auth-Token")
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              
               URLSession.shared.dataTask(with: request) { (data, response, error) in
                  
                   if let httpResponse = response as? HTTPURLResponse{
                       if httpResponse.statusCode == 200{
                        //guard let data = data else {return}
                        //let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
                           DispatchQueue.main.async {
                               self.message = "SUCCESS!"
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
                       if httpResponse.statusCode == 401{
                           DispatchQueue.main.async {
                               self.message = "Unauthorized to complete this request"
                               self.showingAlert = true
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


struct CreateCouponView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCouponView()
    }
}

//
//  LoyaltyView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/9/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct LoyaltyView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var AuthToken: String = (UserDefaults.standard.string(forKey: "AuthToken") ?? nil) ?? ""
    @State var email: String = UserDefaults.standard.string(forKey: "SaveEmail") ?? ""
    @State var points: Int = UserDefaults.standard.integer(forKey: "SavePoints")
    @State var addpoints: Bool = true
    @State var subtractpoints: Bool = false
    @State var message: String = ""
    @State var showingAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("").navigationBarTitle("LOYALTY")
                    .navigationBarItems(trailing:
                    NavigationLink(destination: AccountView()){
                    Text("My Account")})
            ScrollView {
                Image("logoheader")
                    .resizable()
                    .scaledToFit()
                    .scaledToFill()
                Text("\(points) pts")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                    .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                HStack {
                     Button(action: {
                         self.subtractpoints = false
                         self.addpoints = true
                     }) {
                         Text("ADD")
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                     }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                     .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                     .cornerRadius(10)
                     .padding(.leading)
                     Button(action: {
                         self.addpoints = false
                         self.subtractpoints = true
                     }) {
                         Text("REDEEM")
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                     }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                     .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                     .cornerRadius(10)
                     .padding(.trailing)
                }
                Divider()
                    .frame(height: 5)
                    .background(Color(red: 75/255, green: 2/255, blue:38/255))
                    .padding([.horizontal])
                if addpoints {
                    Text("ADD POINTS")
                        .fontWeight(.semibold)
                        .padding(.bottom)
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    Text("1 GAME = 100 POINTS")
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                }
                if subtractpoints {
                    Text("REDEEM POINTS")
                        .fontWeight(.semibold)
                        .padding(.bottom)
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    Text("1 GAME REDEEMED = -500 POINTS")
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                }
                Image(uiImage: self.generateQRCode(from: "\(self.email)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Divider()
                    .frame(height: 5)
                    .background(Color(red: 75/255, green: 2/255, blue:38/255))
                    .padding()
                Button(action: {
                    self.GetUserData(AuthToken: self.AuthToken)
                }) {
                    Text("Update")
                }
            }
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Something Went Wrong"), message: Text((message)), dismissButton: .default(Text("OK")))
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
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
                       DispatchQueue.main.async {
                        self.points = UserDefaults.standard.integer(forKey: "SavePoints")
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
}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView()
    }
}

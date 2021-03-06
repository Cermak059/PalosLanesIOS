//
//  LoyaltyView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/9/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

struct LoyaltyView: View {
    @EnvironmentObject var settings: UserSettings
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var AuthToken: String = (UserDefaults.standard.string(forKey: "AuthToken") ?? nil) ?? ""
    @State var email: String = UserDefaults.standard.string(forKey: "SaveEmail") ?? ""
    @State var points: Int = UserDefaults.standard.integer(forKey: "SavePoints")
    @State var addpoints: Bool = true
    @State var subtractpoints: Bool = false
    @State var message: String = ""
    @State var showingAlert: Bool = false
    @State var showAccount: Bool = false
    @State var showInfo: Bool = false
    let CenterId: String = "PalosLanes"
    
    var body: some View {
        VStack {
            Text("").navigationBarTitle("LOYALTY",displayMode: .inline)
                        .navigationBarItems(trailing:
                NavigationLink(destination: AccountView()){
                    Text("My Account")})
            Image("maskinunit")
                .resizable()
                .scaledToFit()
            Text("Points").foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                .padding(.top)
            Text("\(points)")
                .font(.custom("Georgia-Bold", size: 60))
                .fontWeight(.semibold)
                .padding(.bottom)
                .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
            Button(action: {
                self.GetUserData(AuthToken: self.AuthToken)
            }) {
                Text("Update Points")
                    .foregroundColor(.white)
                    .padding(5)
            }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                .background(Color(red: 75/255, green: 2/255, blue:38/255))
                .cornerRadius(10)
                .padding(10)
                .shadow(radius: 10)
            Spacer()
            Image(uiImage: self.generateQRCode(from: "\(self.email)\n\(self.CenterId)"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 200, maxWidth: 250, minHeight: 200, maxHeight: 250)
            Spacer()
            Button(action: {
                self.showInfo.toggle()
            }) {
                Text("How do i earn points?")
                    .padding()
            }
        }.frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width, maxHeight:UIScreen.main.bounds.height)
        .background(Image("approach")
        .resizable()
        .edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Something Went Wrong"), message: Text((message)), dismissButton: .default(Text("OK")))
        }
         .sheet(isPresented: $showInfo, content: {InfoView()})
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
                    guard let finalData = try? JSONDecoder().decode(DataMessage.self, from: data) else {
                        self.message = "Data is corrupt...Please try again!"
                        self.showingAlert = true
                        return
                    }
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

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("LOYALTY POINTS")
                .font(.largeTitle)
                .padding()
            Text("Loyalty points are a great way to earn something every single time you bowl with us. Once you have enough points you can redeem them for cool stuff!")
                .padding(.horizontal)
            Text("Add Points")
                .font(.title).padding()
            Text("Each game of bowling paid for = 100 points. No limit on number of points you can earn per visit!")
                .padding(.horizontal)
            Text("Redeem Points")
                .font(.title).padding()
            Text("Every game you choose to redeem with points removes 500 points from your account. No limit on number of games you can redeem!")
                .padding(.horizontal)
            Spacer()
        }
    }
}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView()
    }
}

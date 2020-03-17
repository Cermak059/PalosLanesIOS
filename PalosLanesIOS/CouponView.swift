//
//  CouponView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/9/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct CouponView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var message: String = ""
    @State var showingAlert: Bool = false
    @State var AuthToken: String = (UserDefaults.standard.string(forKey: "AuthToken") ?? nil) ?? ""
    @State var email: String = UserDefaults.standard.string(forKey: "SaveEmail") ?? ""
    @State var isCoupon: Bool = false
    @State var isUsed: Bool = false
    @State var showQR: Bool = false
    
    var body: some View {
        VStack {
            Text("").navigationBarTitle("COUPONS")
                    .navigationBarItems(trailing:
                    NavigationLink(destination: AccountView()){
                    Text("My Account")})
            Image("logoheader")
                    .resizable()
                    .scaledToFit()
            Divider()
                .frame(height: 5)
                .background(Color(red: 75/255, green: 2/255, blue:38/255))
                .padding(.horizontal)
            if isCoupon {
                Button(action: {
                    self.showQR = true
                }) {
                    Image("bogoimagecopy")
                    .renderingMode(.original)
                    .padding()
                }
            }
            if isUsed {
                Text("Oops you have already used your coupon for this week!").padding(.horizontal)
                Image("errorsymbol")
            }
            Spacer()
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showQR, content: {
            VStack {
                Text("Please scan this QR code")
                Image(uiImage: self.generateQRCode(from: "\(self.email)"))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                
            }
        })
        .onAppear() {
            self.GetCoupon(AuthToken: self.AuthToken)
        }
    }
    
    func GetCoupon(AuthToken: String) {
    
    guard let url = URL(string: "https://chicagolandbowlingservice.com/api/BuyOneGetOne") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AuthToken, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    //guard let data = data else {return}
                    //let finalData = try! JSONDecoder().decode(DataMessage.self, from: data)
                    DispatchQueue.main.async {
                        self.isCoupon = true
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
                if httpResponse.statusCode == 400{
                    DispatchQueue.main.async {
                        self.isUsed = true
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
}

struct CouponView_Previews: PreviewProvider {
    static var previews: some View {
        CouponView()
    }
}

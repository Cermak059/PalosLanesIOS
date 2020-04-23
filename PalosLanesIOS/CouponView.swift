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
    @State var isBOGOcoupon: Bool = true
    @State var isTHANKScoupon:Bool = true
    @State var isUsed: Bool = false
    @State var BOGOshowQR: Bool = false
    @State var THANKSshowQR: Bool = false
    @State var modalSelection = 1
    @State var showModal: Bool = false
    
    var body: some View {
        VStack {
            Text("").navigationBarTitle("COUPONS")
                    .navigationBarItems(trailing:
                    NavigationLink(destination: AccountView()){
                    Text("My Account")})
            ScrollView {
                Image("logoheader")
                        .resizable()
                        .scaledToFit()
                Divider()
                    .frame(height: 5)
                    .background(Color(red: 75/255, green: 2/255, blue:38/255))
                    .padding(.horizontal)
                if isBOGOcoupon {
                    Button(action: {
                        self.modalSelection = 1
                        self.showModal = true
                    }) {
                        Image("bogoimagecopy")
                        .renderingMode(.original)
                        .padding()
                    }
                }
                if isTHANKScoupon {
                    Button(action: {
                        self.modalSelection = 2
                        self.showModal = true
                   }) {
                       Image("Cermak_ThankYouCoupon")
                       .renderingMode(.original)
                       .padding()
                   }
               }
                if isUsed {
                    Text("Oops Sorry! You have already used your coupon for this week!")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    Image("errorsymbol")
                }
                Spacer()
            }
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showModal, content: {
            if self.modalSelection == 1 {
                VStack {
                    Text("Please scan this BOGO QR code")
                    Image(uiImage: self.generateQRCode(from: "\(self.email)\n\("BOGO")"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                }
            }
            if self.modalSelection == 2 {
                VStack {
                   Text("Please scan this one time QR code")
                   Image(uiImage: self.generateQRCode(from: "\(self.email)\n\("Thank You")"))
                   .interpolation(.none)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 200, height: 200)
               }
            }
        })
        .onAppear() {
            self.GetCoupons(AuthToken: self.AuthToken)
        }
    }
    
    func GetCoupons(AuthToken: String) {
    
    guard let url = URL(string: "http://3.15.199.174:5000/CheckAllCoupons") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AuthToken, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse{
                guard let data = data else {return}
                let finalData = try! JSONDecoder().decode(UsedMessage.self, from: data)
                if httpResponse.statusCode == 200{
                    DispatchQueue.main.async {
                        if finalData.Used?.contains("BOGO") ?? false {
                            self.isBOGOcoupon = false
                        }
                        if finalData.Used?.contains("Thank You") ?? false {
                            self.isTHANKScoupon = false
                        }
                        if finalData.Used?.contains("BOGO") ?? false && finalData.Used?.contains("Thank You") ?? false {
                            self.isUsed.toggle()
                        }
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
                        self.message = "No coupon data found"
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

struct UsedMessage: Codable {
    let Used: [String]?
}

struct CouponView_Previews: PreviewProvider {
    static var previews: some View {
        CouponView()
    }
}

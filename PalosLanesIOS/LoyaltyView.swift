//
//  LoyaltyView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/9/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/*struct MainLoyaltyView: View {
    @State var showMenu: Bool = false
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                LoyaltyView(showMenu: self.$showMenu)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
                if self.showMenu {
                    MenuView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width/2)
                        .transition(.move(edge: .leading))
                }
            }.gesture(drag)
        }
    }
}*/
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
    @State var showAccount: Bool = false
    @State var showInfo: Bool = false
    //@Binding var showMenu: Bool
    let CenterId: String = "PalosLanes"
    
    var body: some View {
        VStack {
            //if self.showMenu {
            Text("").navigationBarTitle("LOYALTY",displayMode: .inline)
                        .navigationBarItems(trailing:
                NavigationLink(destination: AccountView()){
                    Text("My Account")})
                    //.navigationBarHidden(true)
                    //.navigationBarBackButtonHidden(true)
                /*.navigationBarItems(leading:
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }, label:  {Image(systemName: "sidebar.left")}),trailing: Button(action: {
                            self.showAccount = true
                        }, label: {Image(systemName: "person")})
                    )*/
            /*else {
                Text("").navigationBarTitle("HOME")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button(action: {
                        self.showMenu.toggle()
                    }, label:  {Image(systemName: "sidebar.left")}),trailing: Button(action: {
                            self.showAccount = true
                        }, label: {Image(systemName: "person")})
                    )
            }*/
            Image("maskinunit").resizable().scaledToFit()
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

struct InfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Loyalty Points").font(.title).padding()
            Text("Loyalty points are a great way to earn something every single time you bowl with us. Once you have enough points you can redeem them for cool stuff!")
            Spacer()
        }
    }
}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView()
    }
}

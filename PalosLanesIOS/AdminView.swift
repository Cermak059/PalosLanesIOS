//
//  AdminVIew.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/10/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import CodeScanner

struct AdminView: View {
    @State var message: String = ""
    @State var showingPointsAlert: Bool = false
    @State var showingAlert: Bool = false
    @State var AuthToken: String = (UserDefaults.standard.string(forKey: "AuthToken") ?? nil) ?? ""
    @State private var showModal = false
    @State private var modalSelection = 1
    @State private var account: String = ""
    
    var body: some View {
            VStack {
                Text("").navigationBarTitle("ADMIN")
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
                Button(action: {
                    self.modalSelection = 1
                    self.showModal = true
                }) {
                    Text("Scan Points")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    .frame(minWidth: 0, maxWidth:
                    .infinity, maxHeight: 40)
                    .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                    .cornerRadius(10)
                    .padding(.all)
                    }
                Button(action: {
                    self.modalSelection = 2
                    self.showModal = true
                }) {
                    Text("Scan Coupons")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    .frame(minWidth: 0, maxWidth:
                    .infinity, maxHeight: 40)
                    .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                    .cornerRadius(10)
                    .padding([.horizontal, .bottom])
                }
                Spacer()
            }.background(Image("approach")
            .resizable()
            .clipped()
            .edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Alert"), message: Text((message)), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showingPointsAlert) { () -> Alert in
                    Alert(title: Text(account), message: Text("Would you like to add or subtract points from this account?"), primaryButton: .default(Text("ADD"), action: {
                        self.modalSelection = 3
                        self.showModal = true
                    }), secondaryButton: .default(Text("SUBTRACT"), action: {
                        self.modalSelection = 4
                        self.showModal = true
                    }))
            }
            .sheet(isPresented: $showModal, content: {
                if self.modalSelection == 1 {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScanPoints)
                }

                if self.modalSelection == 2 {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
                }

                if self.modalSelection == 3 {
                    AddPickerView()
                }
                if self.modalSelection == 4 {
                    SubtractPickerView()
                }
            })
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.showModal = false
        switch result {
        case .success(let data):
            print("Success with \(data)")
            BOGOrequest(email: data)
        case .failure(let error):
            print("Scanning failed \(error)")
       }
    }
    
    func handleScanPoints(result: Result<String, CodeScannerView.ScanError>) {
          self.showModal = false
          switch result {
          case .success(let data):
              print("Success with \(data)")
              DispatchQueue.main.async { // !! This part important !!
                    self.account = data
                    self.showingPointsAlert = true
              }
            print("Made it")
          case .failure(let error):
              print("Scanning failed \(error)")
         }
      }
    
    func BOGOrequest(email: String) {
        
        guard let url = URL(string: "https://chicagolandbowlingservice.com/api/BuyOneGetOne") else {return}
          
            let body: [String: String] = ["Email": email]
              
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

struct AddPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var strengths = ["0 pts", "1 game: 100 pts", "2 games: 200 pts", "3 games: 300 pts", "4 games: 400 pts", "5 games: 500 pts", "6 games: 600 pts", "7 games: 700 pts", "8 games: 800 pts", "9 games: 900 pts", "10 games: 1000 pts"]

    @State private var selectedPoints = 1

    var body: some View {
        NavigationView {
            VStack {
                Group {
                    Picker(selection: $selectedPoints, label: Text("")) {
                        ForEach(0 ..< strengths.count) {
                        Text(self.strengths[$0]).tag($0)
                            }
                        }
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            print(self.selectedPoints)
                        }) {
                            Text("Confirm")
                        }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                        .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                        .cornerRadius(10)
                        .padding([.horizontal, .top])
                }.navigationBarTitle("ADD POINTS")
            }
        }
    }
}

struct SubtractPickerView: View {
    var strengths = ["1 game -500 pts", "2 games -1000 pts", "3 games -1500 pts", "4 games -2000 pts", "5 games -2500 pts"]

    @State private var selectedPoints = 0

    var body: some View {
        NavigationView {

                Section {
                    Picker(selection: $selectedPoints, label: Text("")) {
                        ForEach(0 ..< strengths.count) {
                            Text(self.strengths[$0])

                        }
                    }
                }
            .navigationBarTitle("SUBTRACT POINTS")
        }
    }
}

struct AdminVIew_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

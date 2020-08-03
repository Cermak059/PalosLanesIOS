//
//  AccountView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/8/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var settings: UserSettings
    @State var points: Int = UserDefaults.standard.integer(forKey: "SavePoints")
    @State var firstname: String = UserDefaults.standard.string(forKey: "SaveFirst") ?? ""
    @State var lastname: String = UserDefaults.standard.string(forKey: "SaveLast") ?? ""
    @State var birthday: String = UserDefaults.standard.string(forKey: "SaveBirthdate") ?? ""
    @State var phone: String = UserDefaults.standard.string(forKey: "SavePhone") ?? ""
    @State var email: String = UserDefaults.standard.string(forKey: "SaveEmail") ?? ""
    @State var league: Bool = UserDefaults.standard.bool(forKey: "SaveLeague")
    @State var boolasString: String = ""
    var body: some View {
        VStack {
            Text("").navigationBarTitle("ACCOUNT", displayMode: .inline)
            ScrollView {
                Image("maskinunit")
                    .resizable()
                    .scaledToFill()
                Text("Available Points: \(points)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("\(firstname) ")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                            + Text("\(lastname)")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                        Text("\(birthday)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                        Text("\(phone)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                        Text("\(email)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                        Text("League Member: ")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                            + Text("\(boolasString)")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    }.padding()
                    Spacer()
                    Image("palospinlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 280)
                        .padding(.trailing)
                }
                Divider()
                    .frame(height: 5)
                    .background(Color(red: 75/255, green: 2/255, blue:38/255))
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    print(self.settings.user)
                    self.settings.logout()
                    print(self.settings.user)
                }){
                    Text("Logout")
                        .foregroundColor(Color(.blue))
                }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                .cornerRadius(10)
                .padding()
            }
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
        .environmentObject(settings)
        .onAppear{
            self.convertBool()
        }
    }
    func convertBool() {
        self.boolasString = String(league)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

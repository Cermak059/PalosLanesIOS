//
//  AccountView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/8/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct AccountView: View {
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
            Text("").navigationBarTitle("ACCOUNT")
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
            Text("\(points) points").font(.title).padding()
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(firstname) ")
                    + Text("\(lastname)")
                    Text("\(birthday)")
                    Text("\(phone)")
                    Text("\(email)")
                    Text("League Member: ")
                    + Text("\(boolasString)")
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
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
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

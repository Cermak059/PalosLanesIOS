//
//  AccountView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/8/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct AccountView: View {
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
            Spacer()
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

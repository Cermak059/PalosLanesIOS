//
//  AdminVIew.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/10/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct AdminVIew: View {
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
                NavigationLink(destination: AccountView()) {
                    Text("Scan Points")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                }.frame(minWidth: 0, maxWidth:
                .infinity, maxHeight: 40)
                .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                .cornerRadius(10)
                    .padding(.all)
                NavigationLink(destination: AccountView()) {
                    Text("Scan Coupons")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                }.frame(minWidth: 0, maxWidth:
                            .infinity, maxHeight: 40)
                            .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                            .cornerRadius(10)
                            .padding([.horizontal, .bottom])
                Spacer()
            }.background(Image("approach")
            .resizable()
            .clipped()
            .edgesIgnoringSafeArea(.all))
    }
}

struct AdminVIew_Previews: PreviewProvider {
    static var previews: some View {
        AdminVIew()
    }
}

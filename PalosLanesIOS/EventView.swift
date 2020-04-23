//
//  EventView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/9/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct EventView: View {
    var body: some View {
        VStack {
            Text("").navigationBarTitle("PACKAGES")
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
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    Image("Cermak_StrikePackage")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                    Image("Cermak_SparePackage")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                    Image("Cermak_SaturdayFamilySavings")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                    }
                }
            Divider()
                .frame(height: 5)
                .background(Color(red: 75/255, green: 2/255, blue:38/255))
                .padding(.horizontal)
            Text("Call us at 708-974-3200 for availability")
                .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
            Spacer()
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}

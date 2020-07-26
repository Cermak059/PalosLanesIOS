//
//  MenuView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 7/2/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 75/255, green: 2/255, blue:38/255),Color(red: 75/255, green: 2/255, blue:38/255),.black]), startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading) {
                Image("maskinunit")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 40)
            NavigationLink(destination: HomeView()) {
                HStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                        .imageScale(.large)
                    Text("Home")
                        .foregroundColor(.white)
                        .font(.headline)
                    }.padding()
            }
            Divider()
                .frame(height: 2)
                .background(Color(.white))
                .padding(.horizontal)
            NavigationLink(destination: LoyaltyView()) {
                HStack {
                    Image(systemName: "qrcode")
                        .foregroundColor(.white)
                        .imageScale(.large)
                    Text("Loyalty")
                        .foregroundColor(.white)
                        .font(.headline)
                    }.padding()
            }
            HStack {
                Image(systemName: "qrcode")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Coupons")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding()
            HStack {
                Image(systemName: "rosette")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("League Standings")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding()
            HStack {
                Image(systemName: "square.and.pencil")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("League Signup")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding()
            HStack {
                Image(systemName: "bag.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("Party Packages")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding()
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
                    .imageScale(.large)
                Text("My Account")
                    .foregroundColor(.white)
                    .font(.headline)
            }.padding()
            Spacer()
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

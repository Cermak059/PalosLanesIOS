//
//  HomeView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/7/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var firstname: String = UserDefaults.standard.string(forKey: "SaveFirst") ?? ""
    var body: some View {
            VStack {
                Text("").navigationBarTitle("HOME")
                        .navigationBarItems(trailing:
                        NavigationLink(destination: AccountView()){
                        Text("My Account")
                    })
            ScrollView {
                Image("logoheader")
                        .resizable()
                        .scaledToFit()
                Text("Welcome, \(firstname)").font(.title)
                Divider()
                    .frame(height: 5)
                    .background(Color(red: 75/255, green: 2/255, blue:38/255))
                    .padding(.horizontal)
                VStack {
                    NavigationLink(destination: LoyaltyView()) {
                        Image("cermak_panel")
                            .renderingMode(.original)
                            .padding(.top)
                    }
                    NavigationLink(destination: LoyaltyView()) {
                        Image("cermak_panel_redeempoints")
                            .renderingMode(.original)
                            .padding(.top, 10)
                    }
                    NavigationLink(destination: CouponView()) {
                        Image("cermak_panel_scancoupons")
                            .renderingMode(.original)
                            .padding(.top, 10)
                    }
                    NavigationLink(destination: EventView()) {
                        Image("cermak_panel_eventpackages")
                            .renderingMode(.original)
                            .padding(.top, 10)
                    }
                    Button(action: {
                        let formattedString = "http://www.paloslanes.net/leaguestandings1.htm"
                        let url = URL(string: formattedString)!
                        UIApplication.shared.open(url)
                    }){
                        Image("cermak_panel_leaguestandings")
                            .renderingMode(.original)
                            .padding(.top, 10)
                    }
                    Button(action: {
                        let formattedString = "http://www.paloslanes.net/leagues1.htm"
                        let url = URL(string: formattedString)!
                        UIApplication.shared.open(url)
                    }) {
                        Image("cermak_panel_leaguesignup")
                            .renderingMode(.original)
                            .padding(.top, 10)
                    }
                }
                Divider()
                        .frame(height: 5)
                        .background(Color(red: 75/255, green: 2/255, blue:38/255))
                        .padding([.top,.horizontal])
                ScrollView(.horizontal, showsIndicators: true) {
                      HStack {
                           Image("birthdaypic")
                               .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                           Image("beattheclockweb")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                            Image("mondaymadness")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                            Image("wildwednesday")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                            Image("happyhour")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                      }
                }
                Spacer()
            }
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

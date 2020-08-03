//
//  HomeView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/7/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var settings: UserSettings
    @State var firstname: String = UserDefaults.standard.string(forKey: "SaveFirst") ?? ""
    @State var showAccount: Bool = false
    @State var showPackages: Bool = false
    var body: some View {
        VStack{
            Text("").navigationBarTitle("WELCOME").navigationBarHidden(false)
                    .navigationBarItems(trailing:
            NavigationLink(destination: AccountView()){
                    Text("My Account")})
                ScrollView() {
                    Image("logoheader")
                            .resizable()
                            .scaledToFit()
                    Text("Hello, \(firstname)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                    Divider()
                        .frame(height: 2)
                        .background(Color(red: 75/255, green: 2/255, blue:38/255))
                        .padding(.horizontal)
                    bowlRedeem().environmentObject(settings)
                    Leagues()
                    Specials(showPackages: $showPackages)
                }
            }.background(Image("approach")
            .resizable()
            .clipped()
            .edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showPackages, content: {EventView()})
    }
}

struct bowlRedeem: View {
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        VStack {
            HStack {
                Text("BOWL & REDEEM")
                    .font(.custom("Georgia-Bold", size: 25))
                    .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                Spacer()
            }.padding(.leading)
            VStack(spacing: 15) {
                NavigationLink(destination: LoyaltyView()) {
                    Image("cermak_panel")
                        .renderingMode(.original)
                        .cornerRadius(10).shadow(radius: 10)
                }
                NavigationLink(destination: LoyaltyView()) {
                    Image("cermak_panel_redeempoints")
                        .renderingMode(.original)
                        .cornerRadius(10).shadow(radius: 10)
                }
                NavigationLink(destination: CouponView()) {
                    Image("cermak_panel_scancoupons")
                        .renderingMode(.original)
                        .cornerRadius(10).shadow(radius: 10)
                }.padding(.bottom)
            }
            Divider()
                .frame(height: 2)
                .background(Color(red: 75/255, green: 2/255, blue:38/255))
                .padding(.horizontal)
        }
    }
}

struct Specials: View {
    @Binding var showPackages: Bool
    var body: some View {
        return VStack(spacing: 5) {
            HStack {
                Text("SPECIALS")
                    .font(.custom("Georgia-Bold", size: 25))
                    .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                Spacer()
            }.frame(minWidth: 0, maxWidth: .infinity)
            .padding([.horizontal])
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 10) {
                        Button(action: {
                            self.showPackages.toggle()
                        }) {
                           Image("birthdaypic")
                            .renderingMode(.original)
                            .resizable()
                                .cornerRadius(30)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                        }.overlay(HStack {
                            Text("Tap For Offers")
                                .foregroundColor(Color(.blue))
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color(.blue))
                        }.background(Color(.yellow).cornerRadius(5)), alignment: .bottomTrailing)
                           Image("beattheclockweb")
                                .resizable()
                                .cornerRadius(30)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                            Image("mondaymadness")
                                .resizable()
                                .cornerRadius(30)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                            Image("wildwednesday")
                                .resizable()
                                .cornerRadius(30)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                            Image("happyhour")
                                .resizable()
                                .cornerRadius(30)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                      }.padding(.leading)
                }
            Divider()
              .frame(height: 2)
              .background(Color(red: 75/255, green: 2/255, blue:38/255))
                .padding([.horizontal, .top])
            Text("11025 Southwest Highway \nPalos Hills, IL. \n60465\n  708-974-3200").frame(height: 100)
            .font(.custom("Georgia-Bold", size: 15))
            .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
            .multilineTextAlignment(.center)
        }
    }
}

struct Leagues: View {
    var body: some View {
        VStack(spacing:10) {
            HStack {
                Text("LEAGUES")
                .font(.custom("Georgia-Bold", size: 25))
                .foregroundColor(Color(red: 75/255, green: 2/255, blue:38/255))
                Spacer()
            }.padding(.leading)
            Button(action: {
                let formattedString = "http://www.paloslanes.net/leaguestandings1.htm"
                let url = URL(string: formattedString)!
                UIApplication.shared.open(url)
            }){
                Image("cermak_panel_leaguestandings")
                    .renderingMode(.original)
                    .cornerRadius(10).shadow(radius: 10)
            }
            Button(action: {
                let formattedString = "http://www.paloslanes.net/leagues1.htm"
                let url = URL(string: formattedString)!
                UIApplication.shared.open(url)
            }) {
                Image("cermak_panel_leaguesignup")
                    .renderingMode(.original)
                    .cornerRadius(10).shadow(radius: 10)
                    .padding(.bottom)
            }
            Divider()
                .frame(height: 2)
                .background(Color(red: 75/255, green: 2/255, blue:38/255))
                .padding([.horizontal])
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

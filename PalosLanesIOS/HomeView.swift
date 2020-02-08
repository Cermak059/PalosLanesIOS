//
//  HomeView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/7/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("").navigationBarTitle("HOME")
                        .navigationBarItems(trailing:
                        NavigationLink(destination: AccountView()){
                        Text("My Account")
                    })
                Image("logoheader")
                        .resizable()
                        .scaledToFit()
                Divider()
                    .frame(height: 5)
                    .background(Color.red)
                    .padding(.horizontal)
                NavigationLink(destination: AccountView()) {
                    Image("cermak_panel")
                        .renderingMode(.original)
                        .padding(.top)
                }
                NavigationLink(destination: AccountView()) {
                    Image("cermak_panel_redeempoints")
                        .renderingMode(.original)
                        .padding(.top, 10)
                }
                NavigationLink(destination: AccountView()) {
                    Image("cermak_panel_scancoupons")
                        .renderingMode(.original)
                        .padding(.top, 10)
                }
                NavigationLink(destination: AccountView()) {
                    Image("cermak_panel_eventpackages")
                        .renderingMode(.original)
                        .padding(.top, 10)
                }
                Divider()
                        .frame(height: 5)
                        .background(Color.red)
                    .padding([.top,.horizontal])
                ScrollView(.horizontal, showsIndicators: true) {
                      HStack {
                           Image("birthdaypic")
                               .resizable()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                           Image("beattheclockweb")
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

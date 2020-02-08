//
//  ForgotPassView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 2/7/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct ForgotPassView: View {
    @State var forgotPass: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            Image("logoheader")
                .resizable()
                .scaledToFit()
            Text("Password Reset")
                .padding([.leading,.top])
                .font(.title)
            TextField("Ex. bowling123@yahoo.com", text:$forgotPass)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Spacer()
            Button(action: {
                print("Button tapped")
            }) {
                Text("SEND EMAIL")
            }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: 40)
                .background(Color(red: 200/255, green: 211/255, blue: 211/255, opacity: 1.0))
                .cornerRadius(10)
                .padding([.horizontal, .top])
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
}

struct ForgotPassView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassView()
    }
}

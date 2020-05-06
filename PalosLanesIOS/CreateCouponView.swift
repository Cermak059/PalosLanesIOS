//
//  CreateCouponView.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 5/6/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI

struct CreateCouponView: View {
    var body: some View {
        VStack {
            Image("logoheader")
                .resizable()
                .scaledToFit()
            Spacer()
        }.background(Image("approach")
        .resizable()
        .clipped()
        .edgesIgnoringSafeArea(.all))
    }
}

struct CreateCouponView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCouponView()
    }
}

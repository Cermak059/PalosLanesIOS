//
//  UserSettings.swift
//  PalosLanesIOS
//
//  Created by Kyle Cermak on 7/31/20.
//  Copyright © 2020 Kyle Cermak. All rights reserved.
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var user: Bool = false
    @Published var admin: Bool = false
    
    func userlogin() {
        user = true
    }
    func adminlogin() {
        admin = true
    }
    func logout() {
        if user == false {
            user = true
        }
        else {
            user = false
        }
    }
}

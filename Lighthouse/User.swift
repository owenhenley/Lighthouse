//
//  User.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import Firebase


class User {
    
    
    
    let userID          : String
    let username        : String
    let email           : String?
    let friends         : [User] = []
    let profileImageURL : URL = URL(fileURLWithPath: "")
    let currentLocation : Location?


    init(userID: String, currentLocation: Location, username: String, email: String) {
        self.userID = userID
        self.currentLocation = currentLocation
        self.username = username
        self.email = email
    }
    
   
    
}

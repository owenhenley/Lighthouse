//
//  User.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation


class User {
    
    
    
    let userID          : String
    let username        : String
    let email           : String?
    let friends         : [User] = []
//    var profileImageURL : URL?
    var profileImage    : UIImage?
    let currentLocation : Location = Location(title: "", currentLocation: 0, coOrdinates: 0)

    
    
    var isActive        : Bool = true
//    var groups          : [User] = []


    init(userID: String, username: String, email: String) {
        self.userID = userID
        self.username = username
        self.email = email
        
    }
   
    
}



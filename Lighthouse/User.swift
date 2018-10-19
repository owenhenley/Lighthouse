//
//  User.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class User {
    
    let userID          : String
    var username        : String?
    var email           : String?
    let friends         : [User] = []
    var profileImageURL : String?
    var profileImage    : UIImage?
    var currentLocation : Event?
    var firstName       : String?
    var lastName        : String?
    var favLocation1    : String?
    var favLocation2    : String?
    var favLocation3    : String?
    var pastLocations   : [Event]?
    
    var isActive        : Bool = true
//    var groups          : [User] = []

    init(userID: String, username: String, email: String) {
        self.userID   = userID
        self.username = username
        self.email    = email
        
    }
   
}



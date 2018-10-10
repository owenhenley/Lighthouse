//
//  User.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
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
    var currentLocation : Location?
    var firstName       : String?
    var lastName        : String?
    var favLocation1    : String?
    var favLocation2    : String?
    var favLocation3    : String?
    var pastLocations   : [Location]?
    

    
    
    var isActive        : Bool = true
//    var groups          : [User] = []


    init(userID: String, username: String, email: String) {
        self.userID   = userID
        self.username = username
        self.email    = email
        
    }
   
    
}



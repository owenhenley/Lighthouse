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
    var firstName       : String?
    var lastName        : String?
    var fullName        : String{
        set{}
        get{
        let firstName = self.firstName ?? ""
        let lastName = self.lastName ?? ""
        return firstName + " " + lastName
        }
    }
    var email           : String?
    let friends         : [User] = []
    var profileImageURL : String?
    var profileImage    : UIImage?
    var currentLocation : Event?
    var favLocation1    : String?
    var favLocation2    : String?
    var favLocation3    : String?
    var pastLocations   : [Event]?
    
    var isActive        : Bool = true
//    var groups          : [User] = []

    init(userID: String, name: String, email: String) {
        self.userID   = userID
        self.fullName = name
        self.email    = email
        
    }
   
}



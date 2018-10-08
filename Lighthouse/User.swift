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
    
    
    
    let userID          : String!
    let friends         : [String] = []
    let profileImage    : UIImage!
    let currentLocation : Location?

    init(userID: String, profileImage: UIImage, currentLocation: Location) {
        self.userID = userID
        self.profileImage = profileImage
        self.currentLocation = currentLocation
    }
    
    
}

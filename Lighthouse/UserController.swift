//
//  UserController.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import Firebase

class UserController {
    
    var users: [User] = []
   
    let db = Firestore.firestore()
    
    func createUser(userID: String, username: String, email: String, currentLocation: Location){
        db.collection(USER).addDocument(data: [
            USERID : userID,
            USERNAME : username
        ]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                return
            } else {
                let user = User(userID: userID, currentLocation: currentLocation, username: username, email: email)
                self.users.append(user)
            }
            
            
            
            
            
        }
    }
    
  
    
}

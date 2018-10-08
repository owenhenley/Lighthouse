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
    
    private init() {}
    
    static let shared = UserController()
    
    var users: [User] = []
   
    let db = Firestore.firestore()

    
    func logInUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                //FIXME: presentAlertController
            }
        }
    }
    
    func createUser(username: String, email: String, password: String, currentLocation: Location){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
            if let result = result {
                self.db.collection(USER).addDocument(data: [
                    USERID : result.user.uid,
                    USERNAME : username
                ]) { (error) in
                    if let error = error {
                        print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        return
                    } else {
                        let user = User(userID: result.user.uid, currentLocation: currentLocation, username: username, email: email)
                        self.users.append(user)
                    }
                }
            }
        }
    }
    
    func fetchUsers(){
        
    }
    
    func updateUser(userID: String, username: String?, email: String?, profileImageURL: URL?){
        
    }
    
    func togglePrivacy(userID: String, isActive: Bool){
        
    }
    
    func deleteUser(userID: String){
        }
    
    func addFriend(friendUserID: String){
        
    }
    
    
}

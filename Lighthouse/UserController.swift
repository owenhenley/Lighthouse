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
    
    var user: User?
    let uid = Auth.auth().currentUser?.uid
    
    let db = Firestore.firestore()
    
    
    func logInUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                //FIXME: presentAlertController
            }
        }
    }
    
    
    
    func createUser(username: String, email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
            if let result = result {
                self.db.collection(USER).document(result.user.uid).setData([
                    USERID : result.user.uid,
                    USERNAME : username
                ]) { (error) in
                    if let error = error {
                        print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        return
                    } else {
                        let user = User(userID: result.user.uid, username: username, email: email)
                        self.user = user
                    }
                }
            }
        }
    }
    
    func fetchUsers(){
        
    }
    
    func updateUser(username: String?, email: String?, profileImage: UIImage?){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        if let profileImage = profileImage {
            let storageRef = Storage.storage().reference(withPath: "profileImages").child("\(userID).png")
            if let imageData = profileImage.jpegData(compressionQuality: 0.4) {
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                    }
                }
                var downloadURL: String?
                
                storageRef.downloadURL { (url, error) in
                    downloadURL = url?.absoluteString
                    
                    self.db.collection(USER).document(userID).updateData(["imageURL" : downloadURL!]) { (error) in
                        if let error = error {
                            print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        }
                    }
                }
            }
        }
    }
    
    func togglePrivacy(userID: String, isActive: Bool){
        let activate = !isActive
        guard let uid = uid else {return}
        db.collection(USER).document(uid).updateData([
            ISACTIVE : activate
        ]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            } else {
                self.user?.isActive = activate
            }
        }
    }
    
    func deleteUser(){
        guard let uid = uid else {return}
        db.collection(USER).document(uid).delete { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
        }
    }
    
    func addFriend(friendUserID: String){
        
    }
    
    
}

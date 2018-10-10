//
//  UserController.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
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
                    USER_ID : result.user.uid,
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
    
    func fetchFriends(){
        
    }
    
    func fetchUser(){
        guard let uid = uid else {return}
        db.collection(USER).document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
            guard let data = snapshot?.data() else {return}
            if let username = data[USERNAME] as? String,
                let email = data[EMAIL] as? String,
                let profileImageURLString = data[PROFILE_IMAGE_URL] as? String,
                let userID = data[USER_ID] as? String {
                let user = User(userID: userID, username: username, email: email)
                if let profileImageURL = URL(string: profileImageURLString) {
                    URLSession.shared.dataTask(with: profileImageURL, completionHandler: { (data, response, error) in
                        if let error = error {
                            print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        }
                        if let response = response{
                            print("\(response)")
                        }
                        if let data = data {
                            self.user?.profileImage = UIImage(data: data)
                        }
                        
                    }).resume()
                }
                
                self.user = user
            }
        }
    }
    
    func updateUser(username: String?, email: String?, profileImage: UIImage?){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference(withPath: "profileImages").child("\(userID).png")
        var downloadURL: String?

        if let profileImage = profileImage {
            if let imageData = profileImage.jpegData(compressionQuality: 0.4) {
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                storageRef.putData(imageData, metadata: metaData) { (metadata, error) in
                    if let error = error {
                        print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                    }
                    storageRef.downloadURL { (url, error) in
                        downloadURL = url?.absoluteString
                        
                        self.db.collection(USER).document(userID).updateData([
                            PROFILE_IMAGE_URL : downloadURL!,
                            USERNAME : username as Any,
                            EMAIL : email as Any
                        ]) { (error) in
                            if let error = error {
                                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                            }
                        }
                    }
                }
            }
        } else {
            Storage.storage().reference(withPath: storageRef.fullPath).delete { (error) in
                if let error = error {
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                }
            }
            self.db.collection(USER).document(userID).updateData([
                PROFILE_IMAGE_URL : "No profile Image",
                USERNAME : username as Any,
                EMAIL : email as Any
            ]) { (error) in
                if let error = error {
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                }
            }
        }
    }
    
    func togglePrivacy(userID: String, isActive: Bool){
        let activate = !isActive
        guard let uid = uid else {return}
        db.collection(USER).document(uid).updateData([
            IS_ACTIVE : activate
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

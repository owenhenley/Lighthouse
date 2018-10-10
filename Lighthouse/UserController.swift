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
    var uid: String?
    let db = Firestore.firestore()
    
    
    func logInUser(email: String, password: String, completion: @escaping (_ success: Bool) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
                //FIXME: presentAlertController
            } else {
                self.uid = Auth.auth().currentUser?.uid
                self.fetchUser(completion: { (success) in
                    if success{
                        completion(true)
                    }
                })
            }
        }
    }
    
    func createUser(username: String, email: String, password: String, completion: @escaping (_ success: Bool) ->Void){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
            }
            if let result = result {
                FIRESTORE.collection(USER).document(result.user.uid).setData([
                    USER_ID : result.user.uid,
                    USERNAME : username,
                    EMAIL : email,
                    FIRST_NAME : "",
                    LAST_NAME : "",
                    FAV_LOCATION1 : "",
                    FAV_LOCATION2 : "",
                    FAV_LOCATION3 : "",
                    PROFILE_IMAGE_URL : "No Profile Image"
                    //CURRENT_LOCATION
                    //PAST_LOCATIONS
                       
                ]) { (error) in
                    if let error = error {
                        print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        completion(false)
                        return
                    } else {
                        completion(true)
                        let user = User(userID: result.user.uid, username: username, email: email)
                        self.user = user
                    }
                }
            }
        }
    }
    
    func fetchFriends(){
        
    }
    
    func fetchUser(completion: @escaping (_ success: Bool)->Void){
        guard let uid = uid else {return}
        db.collection(USER).document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
                return
            }
            guard let data = snapshot?.data() else {completion(false); return}
            if let username = data[USERNAME] as? String,
                let email = data[EMAIL] as? String,
                let profileImageURLString = data[PROFILE_IMAGE_URL] as? String,
                let userID = data[USER_ID] as? String,
                let firstname = data[FIRST_NAME] as? String,
                let lastname = data[LAST_NAME] as? String,
                let favLocation1 = data[FAV_LOCATION1] as? String,
                let favLocation2 = data[FAV_LOCATION2] as? String,
                let favLocation3 = data[FAV_LOCATION3] as? String {
                let user = User(userID: userID, username: username, email: email)
                user.firstName = firstname
                user.lastName = lastname
                user.favLocation1 = favLocation1
                user.favLocation2 = favLocation2
                user.favLocation3 = favLocation3
                
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
                completion(true)
            }
        }
    }
    
    func updateUser(username: String?, profileImage: UIImage?, firstName: String?, lastName: String?, favLocation1: String?, favLocation2: String?, favLocation3: String?, completion: @escaping (_ success: Bool)->Void){
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
                        completion(false)
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        downloadURL = url?.absoluteString
                        
                        self.db.collection(USER).document(userID).updateData([
                            PROFILE_IMAGE_URL : downloadURL!,
                            USERNAME : username as Any,
                            FIRST_NAME : firstName as Any,
                            LAST_NAME : lastName as Any,
                            FAV_LOCATION1 : favLocation1 as Any,
                            FAV_LOCATION2 : favLocation2 as Any,
                            FAV_LOCATION3 : favLocation3 as Any
                        ]) { (error) in
                            if let error = error {
                                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                                completion(false)
                                return
                            }
                            completion(true)
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
                FIRST_NAME : firstName as Any,
                LAST_NAME : lastName as Any,
                FAV_LOCATION1 : favLocation1 as Any,
                FAV_LOCATION2 : favLocation2 as Any,
                FAV_LOCATION3 : favLocation3 as Any
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

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
    
    var user : User?
    var uid  : String?
    let db = FIRESTORE
    
    func logInUser(email: String, password: String, completion: @escaping (_ success: Bool) -> ()){
        
        AUTH.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
            } else {
//                self.uid = AUTH.currentUser?.uid
                self.fetchUser(completion: { (success) in
                    if success{
                        completion(true)
                    }
                })
                EventController.shared.fetchActivePins()
            }
        }
    }
    
    func createUser(name: String, email: String, password: String, completion: @escaping (_ success: Bool) ->Void){
        AUTH.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
                return
            }
            let splitName = name.components(separatedBy: " ")
            let firstName = splitName.dropLast().joined(separator: " ")
            let lastName = splitName.last
            
            if let result = result {
                
                FIRESTORE.collection(USER).document(result.user.uid).setData([
                    USER_ID           : result.user.uid,
                    NAME              : name,
                    EMAIL             : email,
                    FIRST_NAME        : firstName,
                    LAST_NAME         : lastName ?? "",
                    PROFILE_IMAGE_URL : "No Profile Image",
                    
                    //PAST_LOCATIONS
                    
                ]) { (error) in
                    if let error = error {
                        print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        completion(false)
                        return
                    } else {
                        completion(true)
                        let user = User(userID: result.user.uid, name: name, email: email)
                        self.user = user
                    }
                }
              
            }
            
        }
    }
    

    
    
    
    
    func updateUser(user: User, completion: @escaping (_ success: Bool)->Void){
        
        guard let userID = AUTH.currentUser?.uid else {return}
        let storageRef = Storage.storage().reference(withPath: "profileImages").child("\(userID).png")
        var downloadURL: String?
        
        if let profileImage = user.profileImage {
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
                        
                        //UpdateLocalProlileImageURL
                        user.profileImageURL = downloadURL
                        
                        self.db.collection(USER).document(userID).updateData([
                            PROFILE_IMAGE_URL : downloadURL!,
                            USERNAME          : user.fullName as Any,
                            FIRST_NAME        : user.firstName as Any,
                            LAST_NAME         : user.lastName as Any,
                            FAV_LOCATION1     : user.favLocation1 as Any,
                            FAV_LOCATION2     : user.favLocation2 as Any,
                            FAV_LOCATION3     : user.favLocation3 as Any
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
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription) No profile Image to delete 💩💩")
                }
            }

            self.db.collection(USER).document(userID).updateData([
                PROFILE_IMAGE_URL : "No profile Image",
                USERNAME          : user.fullName as Any,
                FIRST_NAME        : user.firstName as Any,
                LAST_NAME         : user.lastName as Any,
                FAV_LOCATION1     : user.favLocation1 as Any,
                FAV_LOCATION2     : user.favLocation2 as Any,
                FAV_LOCATION3     : user.favLocation3 as Any
            ]) { (error) in
                if let error = error {
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                } else {
                    completion(true)
                }
            }
        }
    }
    
    
    
    
    
    func fetchUser(completion: @escaping (_ success: Bool)->Void){
        self.uid = AUTH.currentUser?.uid
        guard let uid = uid else {return}
        db.collection(USER).document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
                return
            }
            guard let data = snapshot?.data() else {completion(false); return}
            if let name                  = data[NAME] as? String,
               let email                 = data[EMAIL] as? String,
               let profileImageURLString = data[PROFILE_IMAGE_URL] as? String,
               let userID                = data[USER_ID] as? String,
               let firstname             = data[FIRST_NAME] as? String,
               let lastname              = data[LAST_NAME] as? String {
               let user                 = User(userID : userID, name : name, email : email)
               user.firstName            = firstname
               user.lastName             = lastname
               user.profileImageURL      = profileImageURLString
                
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
    
    
    
    
}

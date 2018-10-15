//
//  FriendController.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendController {
    
    private init () {}
    
    static let shared = FriendController()
    
    var results: [Friend] = []{
        didSet{
            NotificationCenter.default.post(name: resultsUpdated, object: nil)
        }
    }
    
    let resultsUpdated = Notification.Name("ResultsUpdated")
    
    
    func requestFriend(friendID: String){
        guard let userID = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).setValue(true, forKey: userID)
        FIRESTORE.collection(USERLIST).document(friendID).collection(REQUESTS).document(userID).setValue(true, forKey: userID)
    }
    func cancelRequest(friendID: String){
        let userID = AUTH.currentUser!.uid
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).delete { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
        }
        FIRESTORE.collection(USERLIST).document(friendID).collection(REQUESTS).document(userID).delete { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
        }
    }
    
    func acceptRequest(friendID: String){
        let userID = AUTH.currentUser!.uid
        
        FIRESTORE.collection(USER).document(friendID).collection(FRIENDLIST).document(userID).setData([userID : true]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
        }
        FIRESTORE.collection(USERLIST).document(friendID).collection(FRIENDLIST).document(userID).setData([userID : true]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
        }
        
        
        cancelRequest(friendID: friendID)
    }
    
    func addFriend(friendID: String, completion: @escaping (_ success: Bool)->Void){
        
        guard let uid = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(uid).collection(FRIENDLIST).document(friendID).setData([FRIEND : friendID]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                return
            }
        }
        
    }
    
    func deleteFriend(friendID: String){
        guard let uid = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(uid).collection(FRIENDLIST).document(friendID).delete()
    }
    
    func fetchFriends(text: String, completion: @escaping (_ success: Bool)->Void){
        FIRESTORE.collection(USERLIST).whereField(USERNAME, isEqualTo: text).limit(to: 15).getDocuments { (snapShotBlock, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion (false)
                return
            }
            guard let users = snapShotBlock?.documents else {return}
            for user in users {
                let username = user[USERNAME] as! String
                let urlString = user[PROFILE_IMAGE_URL] as! String
                let friend = Friend(username: username, image: nil, imageUrl: urlString)
                self.results.append(friend)
                
            }
            completion(true)
        }
    }
    
    func searchFriends(text: String, completion: @escaping (_ success: Bool)->Void){
        self.results = []
        fetchFriends(text: text) { (success) in
            if success {
                completion(true)
            }
        }
    }
    
    func fetchCurrentFriends(text: String, completion: @escaping (_ success: Bool)->Void){
        guard let uid = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(uid).collection(FRIENDLIST).getDocuments { (snapshots, error) in
            guard let friends = snapshots?.documents else {return}
            for friend in friends {
                let friendID = friend[USER_ID] as! String
                self.fetchFriends(text: friendID) { (success) in
                    if !success {
                        print("error")
                    }
                }
            }
        }
    }
    
    func fetchFreindsImage(urlString: String, completion: @escaping (_ success: UIImage?)->Void) {
        guard let url = URL(string: urlString) else {return}
        var profileImage: UIImage?
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                return
            }
            if let data = data {
                profileImage = UIImage(data: data)
                
            }
            completion(profileImage)
            
        }).resume()
    }
    
    
}

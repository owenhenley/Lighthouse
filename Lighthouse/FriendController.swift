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
    
    let resultsUpdated = Notification.Name("ResultsUpdated")
    
    var results: [Friend] = []{
        didSet{
            NotificationCenter.default.post(name: resultsUpdated, object: nil)
        }
    }
    
    var friends: [Friend] = []
    
    
    
    func requestFriend(friendID: String){
        //        from senders perspective: false = request sent, true = other person sent request, nil = no request
        guard let userID = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(userID).collection(REQUESTS).document(friendID).setData([friendID : false])
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).setData([userID : true])
    }
    
    
    func acceptRequest(friendID: String){
        let userID = AUTH.currentUser!.uid
        FIRESTORE.collection(USER).document(userID).collection(REQUESTS).document(friendID).delete()
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).delete()
        FIRESTORE.collection(USER).document(userID).collection(FRIENDLIST).document(friendID).setData([friendID : true])
        FIRESTORE.collection(USER).document(friendID).collection(FRIENDLIST).document(userID).setData([userID : true])
        
        
        //        FIRESTORE.collection(USER).document(friendID).collection(FRIENDLIST).document(userID).setData([userID : true]) { (error) in
        //            if let error = error {
        //                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
        //            }
        //        }
        //        FIRESTORE.collection(USERLIST).document(friendID).collection(FRIENDLIST).document(userID).setData([userID : true]) { (error) in
        //            if let error = error {
        //                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
        //            }
        //        }
        //
        
        //        cancelRequest(friendID: friendID)
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
    
    
    func appendUserInFriendList(uid: String, username: String, profileImageUrl: String, completion: @escaping (_ success: Bool)->Void){
        FIRESTORE.collection(USER).document(uid).collection(FRIENDLIST).document(FRIEND).updateData([
            USERNAME : username,
            PROFILE_IMAGE_URL : profileImageUrl
        ]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion(false)
            } else {
                completion(true)
            }
        }
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
    
    func searchFriends(text: String, completion: @escaping (_ success: Bool) -> Void){
        self.results = []
        FIRESTORE.collection(USER).whereField(USERNAME, isEqualTo: text).limit(to: 15).getDocuments { (snapShotBlock, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion (false)
                return
            }
           
            guard let users = snapShotBlock?.documents else {return}
            for user in users {
                
                let username = user[USERNAME] as! String
                let urlString = user[PROFILE_IMAGE_URL] as! String
                let friendID = user[USER_ID] as! String
               
                self.getRequest(friendID: friendID, completion: { (request) -> Void in
                    let friend = Friend(username: username, image: nil, imageUrl: urlString, friendID: friendID, request: request)
                    self.results.append(friend)
                })
                
            }
            completion(true)
        }
    }
    
    func getRequest(friendID: String, completion: @escaping (_ success: Bool?) -> Void){
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(AUTH.currentUser!.uid).getDocument(completion: { (snapshot, error) in
            guard let request = snapshot else {return}
            if let requestInfo = request[AUTH.currentUser!.uid] as? Bool {
                completion(requestInfo)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    func fetchFriends(completion: @escaping (_ success: Bool)->Void){
        FIRESTORE.collection(USER).document(AUTH.currentUser!.uid).collection(FRIENDLIST).getDocuments { (snapShotBlock, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion (false)
                return
            }
            guard let users = snapShotBlock?.documents else {return}
            for user in users {
                let username = user[USERNAME] as! String
                let urlString = user[PROFILE_IMAGE_URL] as! String
                let friendID = user[USER_ID] as! String
                let friend = Friend(username: username, image: nil, imageUrl: urlString, friendID: friendID, request: true)
                self.friends.append(friend)
                
            }
            completion(true)
        }
        
    }
    
    
    
    
    
//    func fetchCurrentFriends(text: String, completion: @escaping (_ success: Bool)->Void){
//        guard let uid = AUTH.currentUser?.uid else {return}
//        FIRESTORE.collection(USER).document(uid).collection(FRIENDLIST).getDocuments { (snapshots, error) in
//            guard let friends = snapshots?.documents else {return}
//            for friend in friends {
//                let friendID = friend[USER_ID] as! String
//                self.searchFriends(text: friendID) { (success) in
//                    if !success {
//                        print("error")
//                    }
//                }
//            }
//        }
//    }
    
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


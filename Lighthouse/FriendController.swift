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
           
            NotificationCenter.default.post(name: .resultsUpdated, object: nil)
        }
    }
    
    var friends: [Friend] = []{
        didSet{
            NotificationCenter.default.post(name: .friendsUpdated, object: nil)
        }
    }
    
    var pendingReuests: [Friend] = []
    
    
    
    
    func requestFriend(friendID: String){
        //        from senders perspective: false = request sent, true = other person sent request, nil = no request
        guard let userID = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(userID).collection(REQUESTS).document(friendID).setData([friendID : false])
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).setData([userID : true])
    }
    
    
    func acceptRequest(friend: Friend){
        let friendID = friend.friendID
        let userID = AUTH.currentUser!.uid
        FIRESTORE.collection(USER).document(userID).collection(REQUESTS).document(friendID).delete()
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).delete()
        FIRESTORE.collection(USER).document(userID).collection(FRIENDLIST).document(friendID).setData([FRIEND : friendID])
        FIRESTORE.collection(USER).document(friendID).collection(FRIENDLIST).document(userID).setData([FRIEND : userID])
        self.friends.append(friend)
        
       
    }
    
    
    func cancelRequest(friendID: String){
        let userID = AUTH.currentUser!.uid
        FIRESTORE.collection(USER).document(friendID).collection(REQUESTS).document(userID).delete { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
            FIRESTORE.collection(USER).document(userID).collection(REQUESTS).document(friendID).delete()
        }
    }
    
  
    func deleteFriend(friendID: String){
        guard let uid = AUTH.currentUser?.uid else {return}
        FIRESTORE.collection(USER).document(uid).collection(FRIENDLIST).document(friendID).delete()
        FIRESTORE.collection(USER).document(friendID).collection(FRIENDLIST).document(uid).delete()

    }

    func fetchPending(){
        
        guard let currentUser = UID else { return }
        FIRESTORE.collection(USER).document(currentUser).collection(REQUESTS)
            .getDocuments { (snapShot, error) in
                if let error = error {
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                    return
                }
                
                guard let documents = snapShot?.documents else {return}
                
                for docoment in documents {
                    
                    let requestDictionary = docoment.data()
                    if requestDictionary.isEmpty {return}
                    let requestTupal = (requestDictionary.first!.key, requestDictionary.first!.value as? Int)
                    if requestTupal.1 == 1 {
                        let friendID = requestTupal.0
                        self.fetchFriend(friendID: friendID, completion: { (Friend) in
                            var friend = Friend
                            friend.request = false
                            self.pendingReuests.append(friend)
                        }) 
                    }
                }
        }
    }
    
    func searchFriends(text: String, completion: @escaping (_ success: Bool) -> Void){
        self.results = []
        FIRESTORE.collection(USER).whereField(NAME, isEqualTo: text).limit(to: 15).getDocuments { (snapShotBlock, error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                completion (false)
                return
            }
            
            guard let users = snapShotBlock?.documents else {return}
            for user in users {
                
                let username  = user[USERNAME] as! String
                let urlString = user[PROFILE_IMAGE_URL] as! String
                let friendID  = user[USER_ID] as! String
                let firstName = user[FIRST_NAME] as! String
                let lastName  = user[LAST_NAME] as! String
                let name      = firstName + " " + lastName
                
                self.fetchRequest(friendID: friendID, completion: { (request) -> Void in
                    let friend = Friend(image: nil, imageUrl: urlString, friendID: friendID, request: request, name: name, event: nil)
                    self.results.append(friend)
                })
                
            }
            completion(true)
        }
    }
    
    func fetchRequest(friendID: String, completion: @escaping (_ success: Bool?) -> Void){
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
            guard let userIDs = snapShotBlock?.documents else {return}
            for userID in userIDs {
                let friendID = userID[FRIEND] as! String
                self.fetchFriend(friendID: friendID, completion: { (Friend) in
                    self.friends.append(Friend)
                })
            }
            completion(true)
        }
        
    }
    
    func fetchFriend(friendID: String, completion: @escaping (_ success: Friend)->Void){
        FIRESTORE.collection(USER).document(friendID).getDocument(completion: { (user, error) in
            guard let user = user else {return}
//            let username   = user[USERNAME] as! String
            let urlString  = user[PROFILE_IMAGE_URL] as! String
            let friendID   = user[USER_ID] as! String
            let firstName  = user[FIRST_NAME] as! String
            let lastName   = user[LAST_NAME] as! String
            let name       = firstName + " " + lastName
            let friend     = Friend(image : nil, imageUrl : urlString, friendID : friendID, request : true, name : name, event : nil)
            completion(friend)
            
        })
    }
    
}


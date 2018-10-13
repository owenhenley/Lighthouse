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
    
    var friends: [Friend] = [] {
        didSet {
            print(">>>>>", friends, "<<<<<<")
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
    
    
    
    func fetchFriends(text: String, completion: @escaping (_ success: Bool)->Void){
        self.friends = []
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
                self.friends.append(friend)
                
            }
            completion(true)
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

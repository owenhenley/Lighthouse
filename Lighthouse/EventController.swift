//
//  LocationController.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit


class EventController {
    
    static let shared = EventController()
    
    
    func uploadPin(UserLocation: CLLocation, eventVibe: String, eventTitle: String, friendIDs: [String]){
        guard let uid = UID else {return}
        let location = GeoPoint(latitude: UserLocation.coordinate.latitude, longitude: UserLocation.coordinate.longitude)
        let user = UserController.shared.user!
        let firstName = user.firstName ?? ""
        let lastName = user.lastName ?? ""
        let name = firstName + " " + lastName
        let profileImage = user.profileImageURL ?? "No Profile Image"
        FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).setData([
            NAME : name,
            EVENT : eventTitle,
            PROFILE_IMAGE_URL : profileImage,
            ACTIVE_FRIENDS : location,
            EVENT_VIBE : eventVibe
        ]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
        }
        for friendID in friendIDs {
            inviteFriend(friendID: friendID)
        }
    
    }
    
    func inviteFriend(friendID: String){
        guard let uid = UID else {return}
        FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).collection(INVITES).addDocument(data: [FRIEND_ID : friendID]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩 \(friendID)")
            }
        }
        FIRESTORE.collection(USER).document(friendID).collection(ACTIVE_FRIENDS).document(uid).setData([FRIEND_ID : friendID]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩 \(friendID)")
            }
        }
    }
    

    func fetchFriendsPins(){
        guard let uid = UID else {return}

            FIRESTORE.collection(USER).document(uid).collection(ACTIVE_FRIENDS).addSnapshotListener { (snapshot, error) in
                guard let documents = snapshot?.documents else {return}
                let friendIDS: [String] = documents.compactMap{$0[FRIEND_ID]} as! [String]
                for  friendID in friendIDS {
                    FIRESTORE.collection(USER).document(friendID).collection(EVENT).addSnapshotListener({ (snapshot, error) in
                        
                    })
                    FIRESTORE.collection(USER).document(friendID).collection(EVENT).document(friendID).collection(USER_ID).limit(to: 5).addSnapshotListener({ (snapshot, error) in
                        guard let documents = snapshot?.documents else {return}
                        let friendIDS: [String] = documents.compactMap{$0[FRIEND_ID]} as! [String]
                        for friendID in friendIDS {
                            FriendController.shared.fetchFriend(friendID: friendID, completion: { (friend) in
                                
                            })
                        }

                    })
                }
        }
    }
    
   
//    var title: String?
//    var location: CLLocation
//
//    init(title: String, location: CLLocation) {
//        self.title = title
//        self.location = location
//    }
    
    
    
}

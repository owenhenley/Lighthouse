//
//  LocationController.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit
import SVProgressHUD

class EventController {
    
    static let shared = EventController()
    
    var events: [Event] = []{
        didSet{
            NotificationCenter.default.post(name: .eventsUpdated, object: nil)

        }
    }
    var ativeFriends: [String] = []{
        didSet{
            fetchFriendsPins(friendIDs: ativeFriends)
        }
    }
    
    var friendsTrayList: [Friend] = [] {
        didSet {
            NotificationCenter.default.post(name: .friendsTrayUpdated, object: nil)
        }
    }
    
    
    func uploadEvent(event: Event, friendIDs: [String], completion: @escaping (Bool) -> Void){
        guard let uid = UID else {return}
        let location     = GeoPoint(latitude : event.coordinates.latitude, longitude : event.coordinates.longitude)
        let user         = UserController.shared.user!
        let firstName    = user.firstName ?? ""
        let lastName     = user.lastName ?? ""
        let name         = firstName + " " + lastName
        let profileImage = user.profileImageURL ?? "No Profile Image"
        FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).setData([
            NAME              : name,
            EVENT             : event.title,
            PROFILE_IMAGE_URL : profileImage,
            GEO_POINT         : location,
            EVENT_VIBE        : event.vibe
        ]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
            }
            SVProgressHUD.dismiss()
            completion(true)
            
            
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
        FIRESTORE.collection(USER).document(friendID).collection(ACTIVE_FRIENDS).document(uid).setData([FRIEND_ID : uid]) { (error) in
            if let error = error {
                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩 \(friendID)")
            }
        }
    }
    
    func fetchActivePins() {
        guard let uid = UID else {return}
         FIRESTORE.collection(USER).document(uid).collection(ACTIVE_FRIENDS).addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            let friendIDS: [String] = documents.compactMap{$0[FRIEND_ID]} as! [String]
            self.ativeFriends = friendIDS
        }
    }
    
    
    func fetchFriendsPins(friendIDs: [String]){
        for  friendID in friendIDs {
            FIRESTORE.collection(USER).document(friendID).collection(EVENT).addSnapshotListener({ (snapshot, error) in
                guard let document        = snapshot?.documents.first,
                      let name            = document[NAME] as? String,
                      let profileImageURL = document[PROFILE_IMAGE_URL] as? String,
                      let title           = document[EVENT] as? String,
                      let vibe            = document[EVENT_VIBE] as? String,
                      let geoPoint        = document[GEO_POINT] as? GeoPoint
                    else { return }
                
                let location   = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                
                var event = Event(friendID: friendID, name: name, profileImage: nil, profileImageUrl: profileImageURL, title: title, coordinates: location, streetAdrees: "", invited: [], vibe: vibe)
                FIRESTORE.collection(USER).document(friendID).collection(EVENT).document(friendID).collection(USER_ID).addSnapshotListener({ (snapshot, error) in
                    guard let documents = snapshot?.documents else {return}
                    let friendIDS: [String] = documents.compactMap{$0[FRIEND_ID]} as! [String]
                    
                    for friendID in friendIDS {
                        FriendController.shared.fetchFriend(friendID: friendID, completion: { (friend) in
                            event.invited.append(friend)
                        })
                        
                    }
                    self.events.append(event)
                })
            })
        }
    }
}

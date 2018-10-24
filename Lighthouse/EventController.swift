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
    
    var events: [String:Event] = [:]{
        didSet{
            NotificationCenter.default.post(name: .eventsUpdated, object: nil)
        }
    }
    var activeFriends: [String] = []{
        didSet{
            fetchFriendsPins(friendIDs: self.activeFriends)
//            newActiveFriends = []
        }
    }
    
    var removedEvents: [Event] = [] {
        didSet{
            NotificationCenter.default.post(name: .removedFriends, object: nil)
        }
    }
    
    var myEvent: Event?
    
    var invitedFriends: [String] = []
//    var newActiveFriends: [String] = []
    
    
    func uploadEvent(event: Event, friendIDs: [String], completion: @escaping (Bool) -> Void){
        guard let uid = UID else {return}
        let location     = GeoPoint(latitude : event.coordinate.latitude, longitude : event.coordinate.longitude)
        let user         = UserController.shared.user!
        let name         = user.fullName
        let profileImage = user.profileImageURL ?? "No Profile Image"
        FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).setData([
            NAME              : name,
            EVENT             : event.eventTitle,
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
            invitedFriends.append(friendID)
        }
        myEvent = event
    }
    
    func deleteEvent(){
        guard let uid = UID else {return}
        if !invitedFriends.isEmpty {
            FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).collection(INVITES).getDocuments { (snapShot, error) in
                guard let documents = snapShot?.documents else {return}
                let friendIDs = documents.compactMap{$0[FRIEND_ID]} as! [String]
                for friendID in friendIDs {
                    FIRESTORE.collection(USER).document(friendID).collection(ACTIVE_FRIENDS).document(uid).delete()
                }
                FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).delete()
            }
        } else {
            for friendID in invitedFriends {
                FIRESTORE.collection(USER).document(friendID).collection(INVITES).document(uid).delete()
            }
            FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).delete()
        }
        myEvent = nil
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
            let removedFriends = Set(self.activeFriends).subtracting(Set(friendIDS))
            self.removedEvents = Array(removedFriends).compactMap{self.events[$0]}
            self.activeFriends = friendIDS
        }
    }
    
    
    func fetchFriendsPins(friendIDs: [String]){
        for  friendID in friendIDs {
            fetchPin(friendID: friendID)
        }
    }
    
    func fetchPin(friendID: String){
        FIRESTORE.collection(USER).document(friendID).collection(EVENT).addSnapshotListener({ (snapshot, error) in
            guard let document        = snapshot?.documents.first,
                let name            = document[NAME] as? String,
                let profileImageURL = document[PROFILE_IMAGE_URL] as? String,
                let title           = document[EVENT] as? String,
                let vibe            = document[EVENT_VIBE] as? String,
                let geoPoint        = document[GEO_POINT] as? GeoPoint
                else { return }
            
            let location   = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
            
            let event = Event(friendID: friendID, name: name, profileImage: nil, profileImageUrl: profileImageURL, title: title, coordinates: location, streetAddress: "", invited: [:], vibe: vibe, eventTitle: title)
            FIRESTORE.collection(USER).document(friendID).collection(EVENT).document(friendID).collection(INVITES).addSnapshotListener({ (snapshot, error) in
                guard let documents = snapshot?.documents else {return}
                let friendIDS: [String] = documents.compactMap{$0[FRIEND_ID]} as! [String]
                
                for friendID in friendIDS {
                    FriendController.shared.fetchFriend(friendID: friendID, completion: { (friend) in
                        event.invited.updateValue(friend, forKey: friendID)
                    })
                    
                }
                self.events.updateValue(event, forKey: friendID)
            })
        })
    }
}

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
    
    func uploadPin(UserLocation: CLLocation){
        guard let uid = UID else {return}
            
        let location = GeoPoint(latitude: UserLocation.coordinate.latitude, longitude: UserLocation.coordinate.longitude)
        
        FIRESTORE.collection(USER).document(uid).collection(LOCATION).addDocument(data: [
            LOCATION : location,

            ])
    }

    func fetchFriendsPins(){

        let friendIDS: [String] = FriendController.shared.friends.compactMap{$0.friendID}
        for friendID in friendIDS {
            FIRESTORE.collection(USER).document(friendID).collection(LOCATION).addSnapshotListener { (snapshot, error) in

            }

        }
    }
    
   
    var title: String?
    var location: CLLocation
    
    init(title: String, location: CLLocation) {
        self.title = title
        self.location = location
    }
    
    
    
}

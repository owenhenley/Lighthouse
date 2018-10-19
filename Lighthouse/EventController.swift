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
import SVProgressHUD


class EventController {
    
    static let shared = EventController()
    
    var events: [Event] = []
    
    
    func uploadEvent(event: Event, friendIDs: [String], completion: @escaping (Bool) -> Void){
        guard let uid = UID else {return}
        let location = GeoPoint(latitude: event.coordinates.latitude, longitude: event.coordinates.longitude)
        let user = UserController.shared.user!
        let firstName = user.firstName ?? ""
        let lastName = user.lastName ?? ""
        let name = firstName + " " + lastName
        let profileImage = user.profileImageURL ?? "No Profile Image"
        FIRESTORE.collection(USER).document(uid).collection(EVENT).document(uid).setData([
            NAME : name,
            EVENT : event.title,
            PROFILE_IMAGE_URL : profileImage,
            ACTIVE_FRIENDS : location,
            EVENT_VIBE : event.vibe
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
                    guard let document = snapshot?.documents.first,
                        let name = document[NAME] as? String,
                        let profileImageURL = document[PROFILE_IMAGE_URL] as? String,
                        let title = document[EVENT] as? String,
                        let vibe = document[EVENT_VIBE] as? String,
                        let geoPoint = document[GEO_POINT] as? GeoPoint else {return}
                    let location = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                    let clGeoCoder = CLGeocoder()
                    let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    var streetAddress: String?
                    var streetNumber: String?
                    clGeoCoder.reverseGeocodeLocation(clLocation, completionHandler: { (placemarks, error) in
                        guard let placemark = placemarks?.first else {return}
                        streetNumber = placemark.subThoroughfare
                        streetAddress = placemark.thoroughfare
                        if let error = error {
                            print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                        }
                    })
                    
                    let address = (streetAddress ?? "") + " " + (streetNumber ?? "")
                    getProfileImage(urlString: profileImageURL, completion: { (profileImage) in
                        
                        let event = Event(name: name, profileImage: profileImage, title: title, coordinates: location, streetAdrees: address, invited: [], vibe: vibe)
                        self.events.append(event)
                        
                    })
                    
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
        
        func getProfileImage(urlString: String, completion: @escaping (_ success: UIImage?) -> Void) {
            guard let url = URL(string: urlString) else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {return}
                let image = UIImage(data: data)
                completion(image)
                if let error = error {
                    print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
                    completion(nil
                    )
                }
                
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

//
//  Location.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import MapKit

class Event: MKPointAnnotation {
    
    
    var friendID        : String
    var name            : String
    var profileImage    : UIImage?
    var profileImageUrl : String?
    var streetAddress   : String?
    var invited         : [String : Friend]
    var vibe            : String
    var eventTitle      : String

    
    
    
    init(friendID: String, name : String, profileImage: UIImage?, profileImageUrl: String?, title: String, coordinates: CLLocationCoordinate2D, streetAddress: String?, invited: [String:Friend], vibe: String, eventTitle: String) {
        
        self.friendID = friendID
        self.name = name
        self.profileImage = profileImage
        self.profileImageUrl = profileImageUrl
        self.streetAddress = streetAddress
        self.invited = invited
        self.vibe = vibe
        self.eventTitle = eventTitle
        
        super.init()
        super.title = name
        super.coordinate = coordinates
    }
}

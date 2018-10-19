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

struct Event {
    
    var name        : String
    var profileImage: UIImage?
    var title       : String
    var coordinates : CLLocationCoordinate2D
    var streetAdrees: String?
    var invited     : [Friend]
    var vibe        : String
    

    
    
    
//    init(title: String, currentLocation: Double, coordinates: CLLocationCoordinate2D) {
//        self.title       = title
//        self.coordinates = coordinates
//    }
}

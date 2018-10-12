//
//  Location.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Location {
    
    var title           : String!
    var currentLocation : Double!
    var coOrdinates     : Double!
    
    init(title: String, currentLocation: Double, coOrdinates: Double) {
        self.title           = title
        self.currentLocation = currentLocation
        self.coOrdinates     = coOrdinates
    }
    
}


    // MARK: - Foursquare API

struct Root {
    
}



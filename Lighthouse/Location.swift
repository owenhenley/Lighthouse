//
//  Location.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    var title       : String
    var coordinates : CLLocationCoordinate2D
    
    init(title: String, currentLocation: Double, coordinates: CLLocationCoordinate2D) {
        self.title       = title
        self.coordinates = coordinates
    }
}

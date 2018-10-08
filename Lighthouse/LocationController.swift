//
//  LocationController.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController {
   
    var title: String?
    var location: CLLocation
    
    init(title: String, location: CLLocation) {
        self.title = title
        self.location = location
    }
    
}

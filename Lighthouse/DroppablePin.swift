//
//  DroppablePin.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/17/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var identifier: String
    var location: Location?
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
    
}

//
//  Friend.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

struct Friend: Equatable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    
//    let username : String
    var image    : UIImage?
    let imageUrl : String
    let friendID : String
    var request  : Bool?
    var name     : String
    var event    : Event?
    
}

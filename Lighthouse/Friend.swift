//
//  Friend.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class Friend: Equatable, Hashable {
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.friendID == rhs.friendID
    }
    
    
    
//    let username : String
    var image    : UIImage?
    let imageUrl : String
    let friendID : String
    var request  : Bool?
    var name     : String
    var event    : Event?
    var hashValue: Int {
        return friendID.hashValue
    }
    
    
    
    init(image: UIImage?, imageUrl: String, friendID: String, request: Bool?, name: String, event: Event?) {
        self.imageUrl = imageUrl
        self.friendID = friendID
        self.name = name
        self.image = image
        self.request = request
        self.event = event
        
    }
    
}

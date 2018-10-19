//
//  Constants.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 08/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation
import Firebase

let AUTH      = Auth.auth()
let FIRESTORE = Firestore.firestore()
let UID       = Auth.auth().currentUser?.uid

let USER              = "user"
let PROFILE_IMAGE_URL = "profileImageUrl"
let USER_ID           = "userID"
let USERNAME          = "username"
let IS_ACTIVE         = "isActive"
let EMAIL             = "email"
let FIRST_NAME        = "firstName"
let LAST_NAME         = "lastName"
let NAME              = "name"
let FAV_LOCATION1     = "favLocation1"
let FAV_LOCATION2     = "favLocation2"
let FAV_LOCATION3     = "favLocation3"
let USERLIST          = "userList"
let FRIENDLIST        = "friendList"
let FRIEND            = "friend"
let REQUESTS          = "requests"
let FRIEND_ID         = "freindID"
let ACTIVE_FRIENDS    = "activeFriends"
let INVITES           = "invites"
let EVENT             = "event"
let EVENT_VIBE         = "eventVibe"

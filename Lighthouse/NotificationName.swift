//
//  NotificationName.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 18/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let backButtonTapped = Notification.Name("backButtonTapped")
    static let resultsUpdated = Notification.Name("ResultsUpdated")
    static let friendsUpdated = Notification.Name("FriendsUpdated")
    static let signInTapped = Notification.Name("signInTapped")
    static let showTray = Notification.Name("showTray")
}
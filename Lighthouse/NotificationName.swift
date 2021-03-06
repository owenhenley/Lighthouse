//
//  NotificationName.swift
//  Lighthouse
//
//  Created by Levi Linchenko & Owen Henley on 18/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let backButtonTapped = Notification.Name("backButtonTapped")
    static let resultsUpdated = Notification.Name("ResultsUpdated")
    static let friendsUpdated = Notification.Name("FriendsUpdated")
    static let signInTapped = Notification.Name("signInTapped")
    static let showTray = Notification.Name("showTray")
    static let eventsUpdated = Notification.Name("eventsUpdated")
    static let removedFriends = Notification.Name("removedFriends")
    static let removePin = Notification.Name("removePin")
    static let myPinFetched = Notification.Name("myPinFetched")
    static let selectedFriend = Notification.Name("selectedFriend")
    static let regionChanged = Notification.Name("regionChanged")
    static let trayLifted = Notification.Name("trayLifted")
    static let signUpTapped = Notification.Name("signUpTapped")

}

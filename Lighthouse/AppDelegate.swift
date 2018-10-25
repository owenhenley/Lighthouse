//
//  AppDelegate.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        FirebaseApp.configure()
        
        // FIRESTORE FIX : The behavior for system Date objects stored in Firestore is going to change
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
            // MARK: - Create a User
        
//        AUTH.createUser(withEmail: "oh@oh.co", password: "123456") { (auth, error) in
//            if let error = error {
//                debugPrint(error)
//            } else {
//                print("user created")
//            }
//        }
        
        

        
            // MARK: - Sign In
        
//        AUTH.signIn(withEmail: "developer@apple.com", password: "123456") { (auth, error) in
//            if let error = error {
//                debugPrint(error)
//            } else {
//                print("Signedin!")
//            }
//        }
        
        
            // MARK: - Sign Out
        
//        try? AUTH.signOut()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
//
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
}

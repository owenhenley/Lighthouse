//
//  LoadingScreenVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoadingScreenVC: UIViewController {
    
        // MARK: - Outlets
    
    @IBOutlet weak var activityWheel: UIActivityIndicatorView!
    
        // MARK: - Variables
    
    var handle: AuthStateDidChangeListenerHandle?
    
    
        // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityWheel.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        checkUserStateLoading()
        FriendController.shared.fetchPending()
       
        
    }
    
        // MARK: - Authentication
    
    // Check to see if the user is already signed in. Ignore Loading screen if nessasary.
    fileprivate func checkUserStateLoading() {
        handle = AUTH.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                UserController.shared.fetchUser { (success) in
                    
                }
                FriendController.shared.fetchFriends { (success) in
                    if success {
                        print(FriendController.shared.friends)
                    }
                }
                let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
                let mainView = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                self.present(mainView, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let onboarding = storyboard.instantiateViewController(withIdentifier: "onboarding")
                self.present(onboarding, animated: true, completion: nil)
            }
        })
    }
}

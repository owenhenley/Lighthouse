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
        activityWheel.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        AUTH.signIn(withEmail: "owenhenley@me.com", password: "123456") { (auth, error) in
//            if let error = error {
//                debugPrint(error)
//            } else {
//                print("Signedin!")
//            }
//        }
        checkUserState()
    }
    
        // MARK: - Authentication
    
    // Check to see if the user is already signed in. Ignore Loading screen if nessasary.
    func checkUserState() {
        handle = AUTH.addStateDidChangeListener({ (auth, user) in
            if user != nil {
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

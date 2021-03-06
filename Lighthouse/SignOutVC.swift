//
//  SignOutVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/12/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class SignOutVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        try? AUTH.signOut()
        UserController.shared.user = nil
        FriendController.shared.friends = []
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        let mainView = storyboard.instantiateViewController(withIdentifier: "tabBarController")
        mainView.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
        self.present(mainView, animated: true, completion: nil)
    }
    

}

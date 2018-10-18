//
//  TabBarControllerViewController.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class TabBarControllerVC: UITabBarController {
    
        // MARK: - Outlets
    
    @IBOutlet weak var customTabBar: UITabBar!
    
    
        // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        customiseTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar), name: .signInTapped, object: nil)
    }
    
    @objc func showTabBar(){
        tabBar.isHidden = false
        NotificationCenter.default.post(name: .showTray, object: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if AUTH.currentUser == nil {
            self.tabBar.isHidden = true
            self.selectedIndex = 1
        } else {
            self.tabBar.isHidden = false
        }
    }
    
    
    func customiseTabBar() {
        customTabBar.backgroundColor = .white
        customTabBar.isTranslucent = false
    }
}

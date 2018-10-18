//
//  SelectFriendsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/18/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class SelectFriendsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backTapped(_ sender: Any) {
        print("back tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
}

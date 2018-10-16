//
//  TrayTabVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class TrayTabVC: UIViewController {
    
        // MARK: - Outlets
    

    @IBOutlet weak var trayTabHeightContraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func trayOpenTapped(_ sender: Any) {
        trayTabHeightContraint.constant = 10
        print("tapped")
    }
}

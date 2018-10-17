//
//  TrayTabVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

//1) Define all of the qualificcations to be the TrayTabVC's Delegate (Boss)
protocol TrayTabVCDelegate: class {
    func changeTrayHeight(isTrayActive: Bool)
}

class TrayTabVC: UIViewController {
    
    // MARK: - Variables
    
    var trayIsActive = false
    
    //2) The child class defining a place in its heart where it recognizes it needs a boss
    weak var delegate: TrayTabVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func trayOpenTapped(_ sender: Any) {
        delegate?.changeTrayHeight(isTrayActive: trayIsActive)
        trayIsActive = !trayIsActive
    }
}

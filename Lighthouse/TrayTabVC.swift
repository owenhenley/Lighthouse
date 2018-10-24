//
//  TrayTabVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

//1) Define all of the qualifications to be the TrayTabVC's Delegate (Boss)
protocol TrayTabVCDelegate: class {
    func changeTrayHeight()
}

class TrayTabVC: UIViewController {
    
    @IBOutlet weak var trayTabImage: UIImageView!
    
    // MARK: - Variables
    
    
    
    //2) The child class defining a place in its heart where it recognizes it needs a boss
    weak var delegate: TrayTabVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeTray()
        
    }
    
    
    @IBAction func trayOpenTapped(_ sender: Any) {
        
        delegate?.changeTrayHeight()
        NotificationCenter.default.post(name: .trayLifted, object: nil)
//        trayIsActive = !trayIsActive
    }
    
}


extension TrayTabVC: UIGestureRecognizerDelegate {

    
    func swipeTray() {
        
        delegate?.changeTrayHeight()
//        trayIsActive = !trayIsActive
        
        let swipeTray = UISwipeGestureRecognizer(target: self, action: #selector(moveTray))
        swipeTray.delegate = self
        trayTabImage.addGestureRecognizer(swipeTray)
        
        if swipeTray.direction == .up {

        } else if swipeTray.direction == .down {

        }
    }

    @objc func moveTray(sender: UISwipeGestureRecognizer) {
        
    }
    
}

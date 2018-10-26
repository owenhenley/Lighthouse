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
    
        // MARK: - Outlets
    
    @IBOutlet weak var trayTabImage: UIImageView!
    
    // MARK: - Properties
    
    //2) The child class defining a place in its heart where it recognizes it needs a boss
    weak var delegate: TrayTabVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onSwipe(panGesture:)))
        trayTabImage.addGestureRecognizer(panGesture)
        
    }
    
   
    
}




extension TrayTabVC: UIGestureRecognizerDelegate {
  
    @objc func onSwipe(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began {
            delegate?.changeTrayHeight()
            NotificationCenter.default.post(name: .trayLifted, object: nil)
        }
    }
}

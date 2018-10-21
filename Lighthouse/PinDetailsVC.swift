//
//  PinDetailsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/20/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import SVProgressHUD

class PinDetailsVC: UIViewController {

   
    var event: Event?

    @IBOutlet weak var visibleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibleView.layer.shadowColor = UIColor.black.cgColor
        visibleView.layer.shadowOpacity = 0.5
        visibleView.layer.shadowRadius = 5
        visibleView.layer.shadowOffset = CGSize(width: 7.0, height: 3.0)
        visibleView.layer.shadowPath = UIBezierPath(rect: visibleView.bounds).cgPath
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SVProgressHUD.dismiss()
    }
    
    
    
    @IBAction func exitTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

//
//  MapViewVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth

class MapViewVC: UIViewController {
    
        // MARK: - Variables
    
    var locationManager = CLLocationManager()
    
        // MARK: - Outlets

    @IBOutlet weak var mainMapView : MKMapView!
    @IBOutlet weak var nextButton  : UIButton!
    @IBOutlet weak var welcomeCopy : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if Auth.auth().currentUser == nil {
//            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//            let signUpVC = storyboard.instantiateViewController(withIdentifier: "signUpVC")
//            self.present(signUpVC, animated: true)
//        }
        
       self.locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButton) {
        nextButton.isHidden = true
        welcomeCopy.isHidden = true
    }
    
    
    
    
    

 

}

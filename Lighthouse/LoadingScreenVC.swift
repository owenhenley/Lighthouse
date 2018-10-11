//
//  LoadingScreenVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class LoadingScreenVC: UIViewController {
    
    @IBOutlet weak var viewForMap: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showMeAroundButton: UIButton!
    
    // MARK: - Variables
    
    var handle: AuthStateDidChangeListenerHandle?
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        checkUserState()
        blurBackground()
        showMeAroundButton.isHidden = true
    }

    
    // MARK: - Actions
    
    @IBAction func allowLocationTapped(_ sender: Any) {
        requestLocationAuth()
        showMeAroundButton.isHidden = false
    }
    
    
        // MARK: - Location Methods
    
    // Activate location popup
    func requestLocationAuth() {
        checkLocationAuth { (success) in
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Check to see what the users locations state is
    func checkLocationAuth(completion: @escaping (Bool) -> Void) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            completion(true)
            return
        case .denied:
            completion(false)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            completion(false)
            break
        case .authorizedAlways:
            completion(true)
            return
        default:
            // Do it again untill you hit whet you need to
            checkLocationAuth { (success) in
                if success {
                    print("Got their loction! oi oiii")
                }
            }
        }
    }
    
        // MARK: - Authentication
    
    // Check to see if the user is already signed in. Ignore Loading screen if nessasary.
    func checkUserState() {
        handle = AUTH.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
                let mainView = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                self.present(mainView, animated: true, completion: nil)
            }
        })
    }
    
    
        // MARK: - Visual Effects
    
    func blurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = self.viewForMap.bounds
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        self.viewForMap.addSubview(visualEffectView)
    }
    
    
    // Location Services Listener
//    func locationManagerChecker(manager: CLLocationManager, didChangeAuthStatus status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.denied {
//            print("Denied")
//        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
//            print("Allowed")
//        }
//    }
}

extension LoadingScreenVC: CLLocationManagerDelegate {
    
    // set up CoreLocation Delegates
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

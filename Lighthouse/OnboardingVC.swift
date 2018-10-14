//
//  OnboardingVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/11/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class OnboardingVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mainView: UIView!
    
    
        // MARK: - Variables
    
    let locationManager = CLLocationManager()
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocationManager()
        blurBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        requestLocationAuth()
    }
    
    @IBAction func allowLocationTapped(_ sender: Any) {
    }
    
    @IBAction func showMeAroundTapped(_ sender: Any) {
    }
    
    
    // MARK: - Location Methods
    
    // Activate location popup
    func requestLocationAuth() {
        checkLocationAuth { (success) in
            if success {
            self.locationManager.requestWhenInUseAuthorization()
            }
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
    
        // MARK: - Visual Effects
    
    func blurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = self.mainView.bounds
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        self.mainView.addSubview(visualEffectView)
    }
}

extension OnboardingVC: CLLocationManagerDelegate {
    
    // set up CoreLocation Delegates
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

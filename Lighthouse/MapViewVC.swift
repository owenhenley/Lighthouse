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
    let nonAuthUserLocationRadius: Double = 20000
    let authedUserLocationRadius: Double = 400
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainMapView : MKMapView!
    @IBOutlet weak var nextButton  : UIButton!
    @IBOutlet weak var welcomeCopy : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapNonAuthUser()
    }
    
    // MARK: - Actions
    
    @IBAction func nextTapped(_ sender: UIButton) {
        nextButton.isHidden = true
        welcomeCopy.isHidden = true
    }
    
    // MARK: - Location Methods
    
    func getCenterLocation(for map: MKMapView) -> CLLocation {
        
        let latitude = mainMapView.centerCoordinate.latitude
        let longitude = mainMapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - MapMethods
    
    func centerMapNonAuthUser() {
        if let location = locationManager.location?.coordinate {
            UIView.animate(withDuration: 5, delay: 0, options: [], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.nonAuthUserLocationRadius, longitudinalMeters: self.nonAuthUserLocationRadius)
                self.mainMapView.setRegion(region, animated: true)
            }, completion: nil)
        }
    }
}


extension MapViewVC: MKMapViewDelegate {
    
    func startTrackingUserLocation() {
        mainMapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
}

extension MapViewVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
    // Delegates
    func setupLocationManager() {
        mainMapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case . authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            // Show alert instructions
            break
        case .notDetermined:
            // Show location request alert
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert letting them know whats up
            break
        case .authorizedAlways:
             startTrackingUserLocation()
            break
        }
    }
}

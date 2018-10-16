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
    let nonAuthUserLocationRadius: Double = 25000
    let authedUserLocationRadius: Double = 400
    var searchIsActive = false
    var handle: AuthStateDidChangeListenerHandle?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainMapView : MKMapView!
    @IBOutlet weak var nextButton  : UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var fillerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var trayContainer: UIView!
    @IBOutlet weak var trayHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        trayContainer.translatesAutoresizingMaskIntoConstraints = false
//        trayContainer.translatesAutoresizingMaskIntoConstraints = false
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUserState()
        searchView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapNonAuthUser()
//        changeTrayHeight(to: self.view.frame.height)
    }
    
    // MARK: - Actions
    
    @IBAction func searchTapped(_ sender: Any) {
       searchToggled()
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        searchView.isHidden = true
        nextButton.isHidden = true
    }
    
    
    // MARK: - Location Methods
    
    func getCenterLocation(for map: MKMapView) -> CLLocation {
        
        let latitude = mainMapView.centerCoordinate.latitude
        let longitude = mainMapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
        // MARK: - Tray Methods
    
    func changeTrayHeight(to height: CGFloat) {
        self.trayHeightConstraint.constant = height
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first!.location(in: view)
        print(firstTouch.x)
        
    }
    
    // MARK: - MapKit Methods
    
    func centerMapNonAuthUser() {
        if let location = locationManager.location?.coordinate {
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.nonAuthUserLocationRadius, longitudinalMeters: self.nonAuthUserLocationRadius)
                self.mainMapView.setRegion(region, animated: true)
            }, completion: nil)
        }
    }
    
    func centerMapOnAuthedUser() {
        if let location = self.locationManager.location?.coordinate {
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.authedUserLocationRadius, longitudinalMeters: self.authedUserLocationRadius)
                self.mainMapView.setRegion(region, animated: true)
            }, completion: nil)
        }
    }
    
        // MARK: - Search Methods
    
    func searchToggled() {
        if searchIsActive == false {
            searchIsActive = true
            fillerView.isHidden = true
            searchBar.isHidden = false
        } else {
            searchIsActive = false
            fillerView.isHidden = false
            searchBar.isHidden = true
        }
    }
    
        // MARK: - Auth Management
    
    func checkUserState() {
        handle = AUTH.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.nextButton.isHidden = true
                self.centerMapOnAuthedUser()
            }
        })
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

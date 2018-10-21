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
import Firebase
import SVProgressHUD

class MapViewVC: CustomSearchFieldVC {
    
    // MARK: - Properties
    
    var locationManager = CLLocationManager()
    var searchIsActive  = false
    var longPressActive = true
    var userMapCentered = false
    var handle : AuthStateDidChangeListenerHandle?
    let nonAuthUserLocationRadius : Double = 25000
    let authedUserLocationRadius  : Double = 400
    var pinCoordinates: CLLocationCoordinate2D?
    var friendID: String?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainMapView          : MKMapView!
    @IBOutlet weak var nextButton           : UIButton!
    @IBOutlet weak var searchBar            : UISearchBar!
    @IBOutlet weak var fillerView           : UIView!
    @IBOutlet weak var searchView           : UIView!
    @IBOutlet weak var trayContainer        : UIView!
    @IBOutlet weak var trayHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var dropPinButtonView    : UIView!
    @IBOutlet weak var droppedPinButtonView : UIView!
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        searchBar.delegate = self
        trayContainer.translatesAutoresizingMaskIntoConstraints = false
        setupLocationManager()
        addPinLongPress()
        NotificationCenter.default.addObserver(self, selector: #selector(showNextButton), name: .backButtonTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTray), name: .showTray, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(placePins), name: .eventsUpdated, object: nil)
        placePins()
    }
    
    
    //FIXME: Get conainer view to show when user logs in
    @objc func showTray(){
        trayContainer.isHidden = false
    }
    @objc func showNextButton(){
        nextButton.isHidden = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchView.isHidden = false
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkUserState()
    }
    
    
    // MARK: - Actions
    
    @IBAction func searchTapped(_ sender: Any) {
        searchToggled()
        self.resignFirstResponder()
    }
    
    
    @IBAction func nextTapped(_ sender: UIButton) {
        searchView.isHidden = true
        nextButton.isHidden = true
    }
    
    
    // Tapping the Blue GPS Arrow
    @IBAction func findUserLocationTapped(_ sender: Any) {
        centerAuthedUserMapArrowTapped()
    }
    
    // Drop pin at current GPS location
    @IBAction func dropPinTapped(_ sender: Any) {
        dropPinOnCurrentLocation()
    }
    
    // Edit the dropped pin
    @IBAction func droppedPinTapped(_ sender: Any) {
        
    }
    
    @IBAction func unwindToMapViewSegue(_ sender: UIStoryboardSegue) {}
    
    
    // MARK: - Map Methods
    
    func dropPinOnCurrentLocation() {
        centerMapOnAuthedUser {
            self.pinCoordinates = self.mainMapView.centerCoordinate
            let currentLocationPinAnnotation: MKPointAnnotation = MKPointAnnotation()
            currentLocationPinAnnotation.coordinate = self.mainMapView.centerCoordinate
            
            self.mainMapView.addAnnotation(currentLocationPinAnnotation)
            
//            let popover = self.storyboard?.instantiateViewController(withIdentifier: "NewPinPopOver")
//            popover?.modalTransitionStyle = .coverVertical
//            popover?.modalPresentationStyle = .overCurrentContext
//            guard let popoverVC = popover else { return }
            
//             Delays the segue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                self.performSegue(withIdentifier: "toNewPinVC", sender: self)
            }
            
        }
    }
    
    
    func removePin() {
        for annotation in mainMapView.annotations {
            mainMapView.removeAnnotation(annotation)
        }
    }
    
    @objc func placePins(){
        let events = EventController.shared.events
        for event in events {
            
            let friendEventCoordinate = event.coordinates
            let friendEventPinAnnotation: MKPointAnnotation = MKPointAnnotation()
            friendEventPinAnnotation.coordinate = friendEventCoordinate
            friendEventPinAnnotation.title = event.name
            
            friendEventPinAnnotation.subtitle = event.friendID
            
            
//           let friendAnnotation = DroppablePin(coordinate: event.coordinates, identifier: event.friendID)
            mainMapView.addAnnotation(friendEventPinAnnotation)
        }
    }
    
    
    func centerMapNonAuthUser() {
        if userMapCentered == false {
            if let location = locationManager.location?.coordinate {
                UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
                    let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.nonAuthUserLocationRadius, longitudinalMeters: self.nonAuthUserLocationRadius)
                    self.mainMapView.setRegion(region, animated: true)
                }, completion: nil)
            }
            userMapCentered = true
        }
    }
    
    
    func centerMapOnAuthedUser(completion: @escaping () -> ()) {
        if let location = self.locationManager.location?.coordinate {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.authedUserLocationRadius, longitudinalMeters: self.authedUserLocationRadius)
                self.mainMapView.setRegion(region, animated: true)
            }) { (success) in
                completion()
            }
        }
    }
    
    
    // Method to accomodate the GPS Arrow
    func centerAuthedUserMapArrowTapped() {
        if let location = self.locationManager.location?.coordinate {
            UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: {
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
            searchBar.isHidden  = false
            searchBar.becomeFirstResponder()
        } else {
            searchIsActive = false
            fillerView.isHidden = false
            searchBar.isHidden  = true
            searchBar.resignFirstResponder()
        }
    }
    
    
        // MARK: - Auth Management
    
    fileprivate func checkUserState() {
        handle = AUTH.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                
                self.dropPinButtonView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.centerMapOnAuthedUser {
                    }
                }
            } else {
                self.nextButton.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.centerMapNonAuthUser()
                }
            }
            AUTH.removeStateDidChangeListener(self.handle!)
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation?.title != "My Location" else {return}
        self.friendID = view.annotation?.subtitle ?? ""
        self.performSegue(withIdentifier: "toPinDetails", sender: self)
    }
}


    // MARK: - Map Delegate

extension MapViewVC: MKMapViewDelegate {
    
    // Set up map for user tracking
    func startTrackingUserLocation() {
        mainMapView.showsUserLocation     = true
        mainMapView.showsPointsOfInterest = true
        mainMapView.showsBuildings        = true
        mainMapView.userTrackingMode      = .follow
        locationManager.startUpdatingLocation()
    }
    
    
    // Hide keyboard and search bar when the user moved the map
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        searchBar.resignFirstResponder()
        fillerView.isHidden = false
        searchBar.isHidden  = true
    }
}


    // MARK: - Location Methods

extension MapViewVC: CLLocationManagerDelegate {
    
    func getCenterLocation(for map: MKMapView) -> CLLocation {
        let latitude  = mainMapView.centerCoordinate.latitude
        let longitude = mainMapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
    
    // Delegates
    func setupLocationManager() {
        mainMapView.delegate     = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case . authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            #warning("Show alert instructions")
            break
        case .notDetermined:
            // Show location request alert
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            #warning("Show alert letting them know whats up")
            break
        case .authorizedAlways:
            startTrackingUserLocation()
            break
        }
    }
}


    // MARK: - Tray Functions

//1) Adopt the protocol (write that your qualified to be the boss on your resume)
extension MapViewVC: TrayTabVCDelegate {
    
    
    //2 - Implement protocol requirements (Actually fullfill the skills you said you had on your resume)
    func changeTrayHeight(isTrayActive: Bool) {
        
        var height: CGFloat = 0
        if isTrayActive{
            height = self.view.frame.height * 0.55
        }else {
            height = 24
        }
        
        self.trayHeightConstraint.constant = height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    
        // MARK: - Prepare For Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTrayContainer" {
            
            // 3 -  Tell incoming view that you da boss
            let destinationVC = segue.destination as? TrayTabVC
            destinationVC?.delegate = self
        } else if segue.identifier == "toNewPinVC" {
            let destinationVC = segue.destination as? NewPinPopUpVC
            destinationVC?.coordinates = self.pinCoordinates
        } else if segue.identifier == "toPinDetails" {
            SVProgressHUD.show()
            let destinationVC = segue.destination as? PinDetailsVC
            let events = EventController.shared.events.filter{ $0.friendID == self.friendID}
            destinationVC?.event = events.first
//            SVProgressHUD.dismiss()
        }
    }
}

    // MARK: - Long press tap gesture

extension MapViewVC: UIGestureRecognizerDelegate {
    
    func addPinLongPress() {
        if longPressActive == true {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
            longPress.minimumPressDuration = 1
            longPress.delegate = self
            mainMapView.addGestureRecognizer(longPress)
            longPressActive = false
        } else if longPressActive == false {
            longPressActive = true
        }
    }
    
    
    @objc func dropPin(sender: UILongPressGestureRecognizer) {
        
        removePin()
        
        let touchPoint = sender.location(in: mainMapView)
        let touchCoOrdinate = mainMapView.convert(touchPoint, toCoordinateFrom: mainMapView)
        
        let annotation = DroppablePin(coordinate: touchCoOrdinate, identifier: "droppablePin")
        mainMapView.addAnnotation(annotation)
        
        //        let coOdinateRegion = MKCoordinateRegion(center: touchCoOrdinate, latitudinalMeters: 200, longitudinalMeters: 200)
        //        mainMapView.setRegion(coOdinateRegion, animated: true)
        
        
        
    }
}

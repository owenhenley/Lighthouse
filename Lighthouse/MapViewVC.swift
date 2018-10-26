//
//  MapViewVC.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/8/18.
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
    var searchIsActive = false
    var longPressActive = true
    var userMapCentered = false
    var trayActive = false
    var handle : AuthStateDidChangeListenerHandle?
    var friendID : String?
    var myPin : Event?
    let nonAuthUserLocationRadius : Double = 25000
    let authedUserLocationRadius : Double = 400
    var placedAnnotations: Set<String> = []

    
    // MARK: - Outlets
    
    @IBOutlet weak var mainMapView          : MKMapView!
    @IBOutlet weak var searchBar            : UISearchBar!
    @IBOutlet weak var fillerView           : UIView!
    @IBOutlet weak var searchView           : UIView!
    @IBOutlet weak var trayContainer        : UIView!
    @IBOutlet weak var trayHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var dropPinButton        : UIButton!
    @IBOutlet weak var gpsButton            : UIButton!
    @IBOutlet weak var coachmark            : UIView!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.isHidden = true
        searchBar.delegate = self
        dropPinButton.isHidden = true
        trayContainer.translatesAutoresizingMaskIntoConstraints = false
        setupLocationManager()
//        addPinLongPress()
        setupNotificationCenter()
        placePins()
        checkUserState()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
////        searchView.isHidden = false
//    }
    
    
    @objc func displaySelectedPin(notification: NSNotification) {
        guard let event = notification.userInfo?[1] as? Event else {return}
        let region = MKCoordinateRegion(center: event.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.mainMapView.setRegion(region, animated: true)
    }
    
    @objc func placeMyPin(notification: Notification){
        guard let dictionary = notification.userInfo as? [String:Event],
            let uid = UID,
        let myPin = dictionary[uid] else {return}
        self.myPin = myPin
        
        mainMapView.addAnnotation(myPin)
    }
    
    
    @objc func showTray(){
        trayContainer.isHidden = false
    }
    
    //FIXME: Probably remove
    @objc func showNextButton(){
        
    }
    

    // MARK: - Actions
    
    @IBAction func searchTapped(_ sender: Any) {
        searchToggled()
        self.resignFirstResponder()
    }
    
    
    @objc func nextTapped() {
        searchView.isHidden = true
        performSegue(withIdentifier: "toSignUpVC", sender: self)
        changeTrayHeight()
    }
    
    
    // Tapping the Blue GPS Arrow
    @IBAction func findUserLocationTapped(_ sender: Any) {
        centerAuthedUserGPSArrowTapped()
        userMapCentered = true
        gpsButton.setImage(UIImage(named: "gpsActive"), for: .normal)
    }
    
    
    // Drop pin at current GPS location
    @IBAction func dropPinTapped(_ sender: Any) {
        dropPinOnCurrentLocation()
        
    }
    
    
    @IBAction func unwindToMapViewSegue(_ sender: UIStoryboardSegue) {}
    
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(showNextButton), name: .backButtonTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTray), name: .showTray, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(placePins), name: .eventsUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePins), name: .removedFriends, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePin), name: .removePin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(placeMyPin), name: .myPinFetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displaySelectedPin), name: .selectedFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextTapped), name: .signUpTapped, object: nil)
    }
    
    
    // MARK: - Map Methods
    
    // FIXME: - Change to take event as annotation
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let userLocation = mainMapView.view(for: mainMapView.userLocation)
        userLocation?.isUserInteractionEnabled = false
    }
    
    func dropPinOnCurrentLocation() {
        let locationManager = CLLocationManager()
        guard let user = UserController.shared.user,
            let location = locationManager.location?.coordinate,
            let uid = UID else { return }
        
        centerMapOnAuthedUser {
            
            let event = Event(friendID: uid, name: user.fullName, profileImage: user.profileImage, profileImageUrl: user.profileImageURL, title: "", coordinates: location, streetAddress: nil, invited: [:], vibe: "", eventTitle: "")
           
            let eventLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(eventLocation) { (placemarks, error) in
                guard let placemark = placemarks?.first,
                    let street = placemark.thoroughfare,
                    let number = placemark.subThoroughfare  else {return}
                let address = street + " " + number
                event.streetAddress = address
                self.mainMapView.addAnnotation(event)
                self.myPin = event
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                    self.performSegue(withIdentifier: "toNewPinVC", sender: self)
                }
            }
        }
    }
    
    
    @objc func removePin() {
        guard let myPin = myPin else {return}
        mainMapView.removeAnnotation(myPin)
    }
 

    @objc func removePins(){
        for event in EventController.shared.removedEvents {
            EventController.shared.events.removeValue(forKey: event.friendID)
            mainMapView.removeAnnotation(event)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let annoationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annoationView.image = #imageLiteral(resourceName: "mapfriendsiconActive")
        
        if annotation.title == myPin?.title {
            let annoationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoationView.image = #imageLiteral(resourceName: "Pin")
            return annoationView
        }

        if annotation.title == "My Location" {
            return nil
        }
        
        return annoationView
    }
    
    
    @objc func placePins(){
        let events = EventController.shared.events
        for event in events {
            
            let event = event.value
            let usedKey = placedAnnotations.filter{$0 == event.friendID}
            if usedKey.isEmpty {
                
                placedAnnotations.insert(event.friendID)
                mainMapView.addAnnotation(event)
                
            }
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
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.authedUserLocationRadius, longitudinalMeters: self.authedUserLocationRadius)
                self.mainMapView.setRegion(region, animated: true)
            }) { (success) in
                completion()
            }
        }
    }
    
    
    // Method to accomodate the GPS Arrow
    func centerAuthedUserGPSArrowTapped() {
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
                self.dropPinButton.isHidden = false
                self.coachmark.isHidden = true
                    self.centerMapOnAuthedUser {
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.centerMapNonAuthUser()
                }
            }
            AUTH.removeStateDidChangeListener(self.handle!)
        })
    }
    
  
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? Event,
            let uid = UID else {return}
        if annotation.friendID == uid {
            self.performSegue(withIdentifier: "toEditPin", sender: self)
            return
        }
        self.friendID = annotation.friendID
        self.performSegue(withIdentifier: "toPinDetails", sender: self)
    }
}


    // MARK: - Map Delegate

extension MapViewVC: MKMapViewDelegate {
    
    // Set up map for user tracking
    func startTrackingUserLocation() {
        mainMapView.userTrackingMode      = .follow
        locationManager.startUpdatingLocation()
    }
    
    
    // Hide keyboard and search bar when the user moved the map
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        searchBar.resignFirstResponder()
        fillerView.isHidden = false
        searchBar.isHidden  = true
        NotificationCenter.default.post(name: .regionChanged, object: nil)
        if trayActive {
            changeTrayHeight()
        }
        
        userMapCentered = false
        gpsButton.setImage(UIImage(named: "gpsDisabled"), for: .normal)
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
    func changeTrayHeight() {
        trayActive = !trayActive
        var height: CGFloat = 0
        if trayActive{
            coachmark.isHidden = true
            height = self.view.frame.height * 0.55
        } else {
            NotificationCenter.default.post(name: .regionChanged, object: nil)
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
            destinationVC?.event = self.myPin
        } else if segue.identifier == "toPinDetails" {
            guard let friendID = friendID else {return}
            SVProgressHUD.show()
            let destinationVC = segue.destination as? PinDetailsVC
            let event = EventController.shared.events[friendID]
            destinationVC?.event = event
//            SVProgressHUD.dismiss()
        } else if segue.identifier == "toEditPin" {
            let desinationVC = segue.destination as? MyPinVC
            desinationVC?.event = myPin
            
        }
    }
}

    // MARK: - Long press tap gesture

extension MapViewVC: UIGestureRecognizerDelegate {
    
//    func addPinLongPress() {
//        if longPressActive == true {
//            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(dropPin))
//            longPress.minimumPressDuration = 1
//            longPress.delegate = self
//            mainMapView.addGestureRecognizer(longPress)
//            longPressActive = false
//        } else if longPressActive == false {
//            longPressActive = true
//        }
//    }
    
    
//    @objc func dropPin(sender: UILongPressGestureRecognizer) {
//
//        removePin()
//
//        let touchPoint = sender.location(in: mainMapView)
//        let touchCoOrdinate = mainMapView.convert(touchPoint, toCoordinateFrom: mainMapView)
//
//        let annotation = DroppablePin(coordinate: touchCoOrdinate, identifier: "droppablePin")
//        mainMapView.addAnnotation(annotation)
//
//        //        let coOdinateRegion = MKCoordinateRegion(center: touchCoOrdinate, latitudinalMeters: 200, longitudinalMeters: 200)
//        //        mainMapView.setRegion(coOdinateRegion, animated: true)
//
//    }
}



//
//  PinDetailsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/20/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation
import MapKit

class PinDetailsVC: UIViewController {

   
    var event: Event?

    @IBOutlet weak var visibleView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var vibeImageOutlet: UIImageView!
    @IBOutlet weak var sharedWithOne: UIImageView!
    @IBOutlet weak var sharedWithTwo: UIImageView!
    @IBOutlet weak var sharedWithThree: UIImageView!
    @IBOutlet weak var titleInfoOutlet: UILabel!
    @IBOutlet weak var eventNameOutlet: UILabel!
    @IBOutlet weak var distanceOutlet: UILabel!
    @IBOutlet weak var streetAddressOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibleView.layer.shadowColor = UIColor.black.cgColor
        visibleView.layer.shadowOpacity = 0.5
        visibleView.layer.shadowRadius = 5
        visibleView.layer.shadowOffset = CGSize(width: 7.0, height: 3.0)
        visibleView.layer.shadowPath = UIBezierPath(rect: visibleView.bounds).cgPath
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        SVProgressHUD.dismiss()
    }
    
    func updateViews(){
        let locationManager = CLLocationManager()

        guard let event = event,
          let coordinate = locationManager.location?.coordinate else {return}
        titleInfoOutlet.text = "\(event.name) has shared:"
        eventNameOutlet.text = event.eventTitle
        vibeImageOutlet.image = UIImage(named: event.vibe)
        let eventLocation = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
        let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = eventLocation.distance(from: currentLocation)
        let distanceFormatter = MKDistanceFormatter()
        let stringDistance = distanceFormatter.string(fromDistance: distance)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(eventLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first,
                let street = placemark.thoroughfare,
                let number = placemark.subThoroughfare  else {return}
            DispatchQueue.main.async {
                self.streetAddressOutlet.text = number + " " + street
            }
        }
        distanceOutlet.text = stringDistance
        
        if event.profileImageUrl != nil {
            fetchImageWithUrlString(urlString: event.profileImageUrl!) { (image) in
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }
        let inveted = event.invited
        if inveted.count != 0 {
            fetchImageWithUrlString(urlString: inveted.first!.value.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.sharedWithOne.image = image
                }
            }
        }
        if inveted.count > 1 {
            fetchImageWithUrlString(urlString: inveted.randomElement()!.value.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.sharedWithTwo.image = image
                }
            }
        }
        if inveted.count > 2 {
            fetchImageWithUrlString(urlString: inveted.randomElement()!.value.imageUrl) { (image) in
                DispatchQueue.main.async {
                    self.sharedWithThree.image = image
                }
            }
        }

        
    }
    
    
    
    @IBAction func exitTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

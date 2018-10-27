//
//  EditPinVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 23/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import CoreLocation

class MyPinVC: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var sharedWithOutlet: UIImageView!
    @IBOutlet weak var vibeImage: UIButton!
    
    var event: Event?
    
    var selectedVibe = ""
    fileprivate let vibeDictionary: [String: UIImage] = [
        "Movie": #imageLiteral(resourceName: "movieActive"),
        "Food": #imageLiteral(resourceName: "foodActive"),
        "Bar": #imageLiteral(resourceName: "barActive"),
        "Club": #imageLiteral(resourceName: "clubActive"),
        "Concert": #imageLiteral(resourceName: "concertActive"),
        "Party": #imageLiteral(resourceName: "partyActive"),
        "Chill": #imageLiteral(resourceName: "chillActive"),
        "Study": #imageLiteral(resourceName: "foodActive")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        
    }
    
    func updateViews(){
        guard let event = event else {return}
        titleTextField.text = event.eventTitle
        vibeImage.imageView?.image = vibeDictionary[event.vibe]
        locationOutlet.text = "Somewhere Awesome"
        let friend = event.invited.randomElement()?.value
        fetchImageWithUrlString(urlString: friend?.imageUrl ?? "") { (image) in
            DispatchQueue.main.async {
                self.sharedWithOutlet.isHidden = false
                self.sharedWithOutlet.image = image
            }
        }
        
        
        let eventLocation = CLLocation(latitude: event.coordinate.latitude, longitude: event.coordinate.longitude)
        let geoCoder = CLGeocoder()
        

        geoCoder.reverseGeocodeLocation(eventLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first,
                let street = placemark.thoroughfare,
                let number = placemark.subThoroughfare  else {return}
            let address = street + " " + number
            event.streetAddress = address
            self.locationOutlet.text = address
        }
    }
    

    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EditPinVC else {return}
        destinationVC.event = event
    }
 
    
    
    
    @IBAction func eventVibeSelected(_ sender: UIButton) {
//        selectedVibe = vibeDictionary[sender.tag] ?? "No Vibe Selected"
    }
    
    @IBAction func stopSharringTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete this pin?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (_) in
            EventController.shared.deleteEvent()
            NotificationCenter.default.post(name: .removePin, object: nil)
            self.performSegue(withIdentifier: "toMapViewVC", sender: self)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
}

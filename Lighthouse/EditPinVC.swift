//
//  EditPinVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 23/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import CoreLocation

class EditPinVC: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var sharedWithOutlet: UIImageView!
    @IBOutlet weak var vibeImage: UIButton!
    
    var event: Event?
    
    var selectedVibe = ""
    fileprivate let vibeDictionary: [String: UIImage] = [
        "Movie": #imageLiteral(resourceName: "moviesActive"),
        "Food": #imageLiteral(resourceName: "foodActive"),
        "Bar": #imageLiteral(resourceName: "barActive"),
        "Club": #imageLiteral(resourceName: "clubActive"),
        "Concert": #imageLiteral(resourceName: "concertActive"),
        "Party": #imageLiteral(resourceName: "partyActive"),
        "Chill": #imageLiteral(resourceName: "chillActive"),
        "Study": #imageLiteral(resourceName: "studyingActive")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        
    }
    
    func updateViews(){
        guard let event = event else {return}
        titleTextField.text = event.eventTitle
        vibeImage.imageView?.image = vibeDictionary[event.vibe]
       
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func eventVibeSelected(_ sender: UIButton) {
//        selectedVibe = vibeDictionary[sender.tag] ?? "No Vibe Selected"
    }
    
    @IBAction func stopSharringTapped(_ sender: Any) {
        EventController.shared.deleteEvent()
        NotificationCenter.default.post(name: .removePin, object: nil)
    }
    
}

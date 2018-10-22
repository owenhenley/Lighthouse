//
//  NewPinPopUpVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/17/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NewPinPopUpVC: UIViewController {
    
    var event: Event?
    var coordinates: CLLocationCoordinate2D?
    
        // MARK: - Outlets
    
    @IBOutlet weak var exitButton             : UIButton!
    @IBOutlet weak var pinNameTF              : UITextField!
    @IBOutlet weak var latitudeLabel          : UILabel!
    @IBOutlet weak var longitudeLabel         : UILabel!
    @IBOutlet weak var shareWithFriendsButton : UIButton!
    
        // MARK: - Properties
    
    var selectedVibe = ""
    fileprivate let vibeDictionary: [Int: String] = [
        0: "Movie",
        1: "Food",
        2: "Bar",
        3: "Club",
        4: "Concert",
        5: "Party",
        6: "Chill",
        7: "Study"
    ]
    
    
        // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
        // MARK: - Actions
    
    @IBAction func exitTapped(_ sender: Any) {
        self.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareWithFriendsTapped(_ sender: UIButton) {
        
        guard let eventTitle  = pinNameTF.text,
//            let latitude      = latitudeLabel.text,
//            let longitude     = longitudeLabel.text,
            let name          = UserController.shared.user?.firstName,
            let uid = UID,
            let coordinates = coordinates
        else { return }
        
        let eventVibe = selectedVibe
        let event = Event(friendID: uid, name: name, profileImage: nil, profileImageUrl: nil, title: eventTitle, coordinates: coordinates, streetAddress: nil, invited: [:], vibe: eventVibe, eventTitle: eventTitle)
        self.event = event
        self.performSegue(withIdentifier: "selectFreinds", sender: self)
        
        
        // save pin to your account
        // segue to firend selection screen
    }
    
    
    // Event Types
    @IBAction func eventVibeButtonTapped(_ sender: UIButton) {
        selectedVibe = vibeDictionary[sender.tag] ?? "No Vibe Selected"
    }
    

        // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectFreinds" {
            guard let destinationVC = segue.destination as? SelectFriendsVC else {return}
            destinationVC.event = event
        }
    }
}

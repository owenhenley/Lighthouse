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

class NewPinPopUpVC: UIViewController, UITextFieldDelegate {
    
    var event: Event?
    var coordinates: CLLocationCoordinate2D?
    
        // MARK: - Outlets
    
    @IBOutlet weak var exitButton             : UIButton!
    @IBOutlet weak var pinNameTF              : UITextField!
    @IBOutlet weak var addressLabel           : UILabel!
    @IBOutlet weak var shareWithFriendsButton : UIButton!
    @IBOutlet var vibeButtonCollection        : [UIButton]!
    
        // MARK: - Properties
    
    var selectedVibe = ""
    fileprivate let vibeDictionary: [Int : String] = [
        0 : "Movie",
        1 : "Food",
        2 : "Bar",
        3 : "Club",
        4 : "Concert",
        5 : "Party",
        6 : "Chill",
        7 : "Study"
    ]
    
    var currentVibeImage: UIImage?
    fileprivate let vibeImageSelectedDict: [Int : UIImage] = [
        0 : UIImage(named: "moviesActive") ?? UIImage(),
        1 : UIImage(named: "foodActive") ?? UIImage(),
        2 : UIImage(named: "barActive") ?? UIImage(),
        3 : UIImage(named: "clubActive") ?? UIImage(),
        4 : UIImage(named: "concertActive") ?? UIImage(),
        5 : UIImage(named: "partyActive") ?? UIImage(),
        6 : UIImage(named: "chillActive") ?? UIImage(),
        7 : UIImage(named: "studyingActive") ?? UIImage()
    ]
    
    fileprivate let vibeImageDeselectedDict: [Int : UIImage] = [
        0 : UIImage(named: "moviesDisabled") ?? UIImage(),
        1 : UIImage(named: "foodDisabled") ?? UIImage(),
        2 : UIImage(named: "barDisabled") ?? UIImage(),
        3 : UIImage(named: "clubDisabled") ?? UIImage(),
        4 : UIImage(named: "concertDisabled") ?? UIImage(),
        5 : UIImage(named: "partyDisabled") ?? UIImage(),
        6 : UIImage(named: "chillDisabled") ?? UIImage(),
        7 : UIImage(named: "studyingDisabled") ?? UIImage()
    ]
    
    
        // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        pinNameTF.delegate = self
        updateViews()
    }
    
    func updateViews(){
        addressLabel.text = event?.streetAddress
    }
    
    fileprivate func deselectAllButton(except buttonTag: Int) {
        for button in vibeButtonCollection where button.tag != buttonTag{
            button.setImage(vibeImageDeselectedDict[button.tag], for: .normal)
        }
    }
    
    
    func addTapGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    
    @objc func dismissKeyboard(){
        pinNameTF.resignFirstResponder()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    
        // MARK: - Actions
    
    @IBAction func exitTapped(_ sender: Any) {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .removePin, object: nil)
    }
    
    
    @IBAction func shareWithFriendsTapped(_ sender: UIButton) {
        
        guard let eventTitle  = pinNameTF.text,
            let event = event else { return }
        
        let eventVibe = selectedVibe
        
        event.vibe = eventVibe
        event.eventTitle = eventTitle
        
        self.event = event
        self.performSegue(withIdentifier: "selectFreinds", sender: self)
    }
    
    
    // Event Types
    @IBAction func eventVibeButtonTapped(_ sender: UIButton) {
        selectedVibe = vibeDictionary[sender.tag] ?? "No Vibe Selected"
        sender.setImage(vibeImageSelectedDict[sender.tag], for: .normal)
        deselectAllButton(except: sender.tag)
        dismissKeyboard()
    }
    
    
        // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectFreinds" {
            guard let destinationVC = segue.destination as? SelectFriendsVC else {return}
            destinationVC.event = event
        }
    }
}

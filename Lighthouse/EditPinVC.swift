//
//  EditPinVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 25/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditPinVC: UIViewController {
    
    @IBOutlet weak var pinNameOutlet: BorderTextField!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var currentVibeOutlet: UIButton!
    @IBOutlet var vibeButtonCollection        : [UIButton]!
    
    
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews(){
        guard let event = event else {return}
        addressOutlet.text = event.streetAddress
        pinNameOutlet.text = event.eventTitle
        currentVibeOutlet.setImage(UIImage(named: "\(event.vibe.lowercased())Active"), for: .normal)
    }
    
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
        0 : UIImage(named: "movieActive") ?? UIImage(),
        1 : UIImage(named: "foodActive") ?? UIImage(),
        2 : UIImage(named: "barActive") ?? UIImage(),
        3 : UIImage(named: "clubActive") ?? UIImage(),
        4 : UIImage(named: "concertActive") ?? UIImage(),
        5 : UIImage(named: "partyActive") ?? UIImage(),
        6 : UIImage(named: "chillActive") ?? UIImage(),
        7 : UIImage(named: "studyActive") ?? UIImage()
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
    
    fileprivate func deselectAllButton(except buttonTag: Int) {
        for button in vibeButtonCollection where button.tag != buttonTag{
            button.setImage(vibeImageDeselectedDict[button.tag], for: .normal)
        }
    }

 
    
    @IBAction func eventTapped(_ sender: UIButton) {
        selectedVibe = vibeDictionary[sender.tag] ?? "No Vibe Selected"
        sender.setImage(vibeImageSelectedDict[sender.tag], for: .normal)
        deselectAllButton(except: sender.tag)
        currentVibeOutlet.setImage(vibeImageSelectedDict[sender.tag], for: .normal)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        SVProgressHUD.show()
        guard let event = event else {return}
        event.eventTitle = pinNameOutlet.text ?? ""
        event.vibe = selectedVibe
        EventController.shared.uploadEvent(event: event, friendIDs: []) { (true) in
            if true {
                self.performSegue(withIdentifier: "toMapView", sender: self)
            }
        }
    }
    
    
    
    
    @IBAction func stopSharingTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete this pin?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (_) in
            EventController.shared.deleteEvent()
            NotificationCenter.default.post(name: .removePin, object: nil)
            self.performSegue(withIdentifier: "toMapView", sender: self)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    
    
}



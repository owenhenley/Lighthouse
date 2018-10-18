//
//  NewPinPopUpVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/17/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class NewPinPopUpVC: UIViewController {
    
        // MARK: - Outlets
    
    @IBOutlet weak var exitButton             : UIButton!
    @IBOutlet weak var pinNameTF              : UITextField!
    @IBOutlet weak var pinLocationLabel       : UILabel!
    @IBOutlet weak var shareWithFriendsButton : UIButton!
    
    
        // Vibe Outlets
    
    
    
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
        // save pin to your account
        // segue to firend selection screen
    }
    
    
    
    // Event Types
    @IBAction func eventVibeButtonTapped(_ sender: UIButton) {
        selectedVibe = vibeDictionary[sender.tag] ?? ""
        print(selectedVibe)
    }
    
    

        // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

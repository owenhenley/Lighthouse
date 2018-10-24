//
//  EditPinVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 23/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class EditPinVC: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var editButtonOutlet: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        selectedVibe = vibeDictionary[sender.tag] ?? "No Vibe Selected"
    }
    
    @IBAction func stopSharringTapped(_ sender: Any) {
        EventController.shared.deleteEvent()
        NotificationCenter.default.post(name: .removePin, object: nil)
    }
    
}

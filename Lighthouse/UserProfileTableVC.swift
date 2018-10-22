//
//  UserProfileTableVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 10/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SVProgressHUD

class UserProfileTableVC: UITableViewController {
    
        // MARK: - Outlets
    
    @IBOutlet weak var profilePicOutlet : UIImageView!
    @IBOutlet weak var UsernameEdit     : UITextField!
    @IBOutlet weak var firstNameEdit    : UITextField!
    @IBOutlet weak var lastNameEdit     : UITextField!
    @IBOutlet weak var editButtonOutlet : UIButton!
    @IBOutlet weak var addImageOutlet   : UIButton!
    @IBOutlet weak var cancelOutlet     : UIButton!
    @IBOutlet weak var profileMapView   : MKMapView!

  
        // MARK: - Variables
    
    let locationManager = CLLocationManager()
    let authedUserRadius: Double = 500
    
    
        // MARK: - LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        startTrackingUserLocation()
        centerMapOnAuthedUser()
        disableEditing()
        picker.delegate = self
        updateViews()
    }
    
        // MARK: - Actions
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Table view data source
    //Commented for modata
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return UserController.shared.user?.pastLocations?.count ?? 0
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "pastLocationCell", for: indexPath)
//
//        guard let pastLocation = UserController.shared.user?.pastLocations?[indexPath.row] else {return UITableViewCell()}
//        cell.textLabel?.text = pastLocation.title
//        cell.detailTextLabel?.text = String(pastLocation.coOrdinates)
//
//        return cell
//    }
    
    
    
    func disableEditing(){
        
        editButtonOutlet.setTitle("Edit", for: .normal)
        addImageOutlet.isEnabled = false
        addImageOutlet.isHidden = true
        firstNameEdit.isEnabled = false
        lastNameEdit.isEnabled = false
        UsernameEdit.isEnabled = false
        cancelOutlet.isHidden = true
        addImageOutlet.isHidden = true
        
    }
    
    func enableEditing(){
        editButtonOutlet.setTitle("Save", for: .normal)
        addImageOutlet.isEnabled = true
        addImageOutlet.isHidden = false
        firstNameEdit.isEnabled = true
        lastNameEdit.isEnabled = true
        UsernameEdit.isEnabled = true
        cancelOutlet.isHidden = false
    }
    
    
    func updateViews(){
        guard let user = UserController.shared.user else {return}
        UsernameEdit.text = user.fullName
        firstNameEdit.text = user.firstName
        lastNameEdit.text = user.lastName
        if user.profileImage == nil {
            profilePicOutlet.image = #imageLiteral(resourceName: "personIconDisabled")
        } else {
            profilePicOutlet.image = user.profileImage
        }
        
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if editButtonOutlet.titleLabel?.text == "Edit"{
            enableEditing()
        } else {
            SVProgressHUD.show()
            guard let user = UserController.shared.user else {return}
//            user.fullName = UsernameEdit.text
            user.firstName = firstNameEdit.text
            user.lastName = lastNameEdit.text
            
            if profilePicOutlet.image == UIImage(named: "defaultProfPic") {
                user.profileImage = nil
            } else {
                user.profileImage = profilePicOutlet.image
            }
            
            UserController.shared.updateUser(user: user) { (success) in
                if success{
                    self.disableEditing()
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        updateViews()
        disableEditing()
    }
    
    
    let picker = UIImagePickerController()
    @IBAction func addImageTapped(_ sender: Any) {
        self.presentImagePicker(picker: picker)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            profilePicOutlet.image = image
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension UserProfileTableVC: MKMapViewDelegate {
    
    func startTrackingUserLocation() {
        profileMapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func setupLocationManager() {
        profileMapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension UserProfileTableVC: CLLocationManagerDelegate {
    
    func centerMapOnAuthedUser() {
        if let location = locationManager.location?.coordinate {
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.authedUserRadius, longitudinalMeters: self.authedUserRadius)
                self.profileMapView.setRegion(region, animated: true)
            }, completion: nil)
        }
    }
    
}


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

class UserProfileVC: UIViewController {
    
        // MARK: - Outlets
    
    @IBOutlet weak var profilePicOutlet : UIImageView!
    @IBOutlet weak var firstNameTF    : UITextField!
    @IBOutlet weak var lastNameTF     : UITextField!
    @IBOutlet weak var editButton : UIButton!
    @IBOutlet weak var changeImageButton   : UIButton!
    @IBOutlet weak var cancelOutlet     : UIButton!
    @IBOutlet weak var profileMapView   : MKMapView!
    @IBOutlet weak var appVersionNumber: UILabel!
    
  
        // MARK: - Variables
    
    let locationManager = CLLocationManager()
    let authedUserRadius: Double = 500
    let picker = UIImagePickerController()
    
    
        // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appVersionNumber.text = GetAppVersion.getVersion()
        setupLocationManager()
        startTrackingUserLocation()
        centerMapOnAuthedUser()
        disableEditing()
        picker.delegate = self
        updateViews()
    }
    
        // MARK: - Actions
    
    // Unwind Segue
    @IBAction func returnToUserProfile(_ sender: UIStoryboardSegue) {}
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if editButton.titleLabel?.text == "Edit"{
            enableEditing()
        } else {
            SVProgressHUD.show()
            guard let user = UserController.shared.user else {return}
            user.firstName = firstNameTF.text
            user.lastName = lastNameTF.text
            
            if profilePicOutlet.image == UIImage(named: "defaultProfPic") {
                user.profileImage = nil
            } else {
                user.profileImage = profilePicOutlet.image
            }
            
            UserController.shared.updateUser(user: user) { (success) in
                if success{
                    self.disableEditing()
                    SVProgressHUD.dismiss()
                    self.cancelOutlet.isHidden = true
                }
            }
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        updateViews()
        disableEditing()
        cancelOutlet.isHidden = true
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        self.presentImagePicker(picker: picker)
    }
    
    
        // MARK: - Methods
    
    func disableEditing(){
        editButton.setTitle("Edit", for: .normal)
        changeImageButton.isEnabled = false
        changeImageButton.isHidden = true
        firstNameTF.isEnabled = false
        firstNameTF.borderStyle = .none
        firstNameTF.backgroundColor = .clear
        lastNameTF.isEnabled = false
        lastNameTF.borderStyle = .none
        lastNameTF.backgroundColor = .clear
        changeImageButton.isHidden = true
    }
    
    func enableEditing(){
        editButton.setTitle("Save", for: .normal)
        changeImageButton.isEnabled = true
        changeImageButton.isHidden = false
        firstNameTF.isEnabled = true
        firstNameTF.borderStyle = .roundedRect
        firstNameTF.backgroundColor = .white
        lastNameTF.isEnabled = true
        lastNameTF.borderStyle = .roundedRect
        lastNameTF.backgroundColor = .white
        cancelOutlet.isHidden = false
    }
    
    
    func updateViews(){
        guard let user = UserController.shared.user else {return}
        firstNameTF.text = user.firstName
        lastNameTF.text = user.lastName
        
        if user.profileImage == nil {
            profilePicOutlet.image = #imageLiteral(resourceName: "defaultProfPic")
        } else {
            profilePicOutlet.image = user.profileImage
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            profilePicOutlet.image = image
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


extension UserProfileVC: MKMapViewDelegate {
    
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

extension UserProfileVC: CLLocationManagerDelegate {
    
    func centerMapOnAuthedUser() {
        if let location = locationManager.location?.coordinate {
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn], animations: {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: self.authedUserRadius, longitudinalMeters: self.authedUserRadius)
                self.profileMapView.setRegion(region, animated: true)
            }, completion: nil)
        }
    }
    
}


//
//  UserProfileTableVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 10/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class UserProfileTableVC: UITableViewController {
    
    
    @IBOutlet weak var profilePicOutlet: UIImageView!
    
    @IBOutlet weak var UsernameEdit: UITextField!
    @IBOutlet weak var firstNameEdit: UITextField!
    @IBOutlet weak var lastNameEdit: UITextField!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var favLocation1Text: UITextField!
    @IBOutlet weak var favLocation2Text: UITextField!
    @IBOutlet weak var favLocation3Text: UITextField!
    @IBOutlet weak var addImageOutlet: UIButton!
    @IBOutlet weak var cancelOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableEditing()
        picker.delegate = self
        if let user = UserController.shared.user {
            UsernameEdit.text = user.username
            firstNameEdit.text = user.firstName
            lastNameEdit.text = user.lastName
            favLocation1Text.text = user.favLocation1
            favLocation2Text.text = user.favLocation2
            favLocation3Text.text = user.favLocation3
            profilePicOutlet.image = user.profileImage
        }
    }
    
        // MARK: - Actions
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserController.shared.user?.pastLocations?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastLocationCell", for: indexPath)
        
        guard let pastLocation = UserController.shared.user?.pastLocations?[indexPath.row] else {return UITableViewCell()}
        cell.textLabel?.text = pastLocation.title
        cell.detailTextLabel?.text = String(pastLocation.coOrdinates)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func disableEditing(){
        
        favLocation1Text.isEnabled = false
        favLocation2Text.isEnabled = false
        favLocation3Text.isEnabled = false
        editButtonOutlet.setTitle("Edit", for: .normal)
        addImageOutlet.isEnabled = false
        firstNameEdit.isEnabled = false
        lastNameEdit.isEnabled = false
        UsernameEdit.isEnabled = false
        
    }
    
    func enableEditing(){
        favLocation1Text.isEnabled = true
        favLocation2Text.isEnabled = true
        favLocation3Text.isEnabled = true
        editButtonOutlet.setTitle("Save", for: .normal)
        addImageOutlet.isEnabled = true
        firstNameEdit.isEnabled = true
        lastNameEdit.isEnabled = true
        UsernameEdit.isEnabled = true
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if editButtonOutlet.titleLabel?.text == "Edit"{
            enableEditing()
        } else {
            guard let username = UsernameEdit.text,
                let firstName = firstNameEdit.text,
                let lastName = lastNameEdit.text,
                let profileImage = profilePicOutlet.image,
                let favLocation1 = favLocation1Text.text,
                let favLocation2 = favLocation2Text.text,
                let favLocation3 = favLocation3Text.text else {return}
            UserController.shared.updateUser(username: username, profileImage: profileImage, firstName: firstName, lastName: lastName, favLocation1: favLocation1, favLocation2: favLocation2, favLocation3: favLocation3) { (success) in
                if success{
                    self.disableEditing()
                }
            }
        }
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

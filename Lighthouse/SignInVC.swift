//
//  SignInVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailOutlet    : UITextField!
    @IBOutlet weak var passwordOutlet : UITextField!
    @IBOutlet weak var usernameOutlet : UITextField!

    
    
    
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

    @IBAction func signInTapped(_ sender: Any) {
        guard let username = usernameOutlet.text,
            let password = passwordOutlet.text,
            let email = emailOutlet.text else {return}
        UserController.shared.createUser(username: username, email: email, password: password)
    }
    
    
    

    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage{
//            profileImageOutlet.image = image
//        }
//        dismiss(animated: true, completion: nil)
//    }
}

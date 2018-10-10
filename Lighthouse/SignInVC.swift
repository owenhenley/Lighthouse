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
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {

    }
    
    
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

//
//  SignInVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/8/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import SVProgressHUD

//protocol PopScreen: class {
//    func popScreen()
//}

class SignInVC: CustomTextFieldVC {
    
    @IBOutlet weak var emailOutlet    : UITextField!
    @IBOutlet weak var passwordOutlet : UITextField!
    @IBOutlet weak var blurView       : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordOutlet.delegate = self
        textFields = [emailOutlet, passwordOutlet]
        blurBackground()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signInTapped(self)
        return true
    }
    
//    weak var delegate: PopScreen?
    
        // MARK: - Unwind
    @IBAction func backToSignin(_ sender: UIStoryboardSegue) {}
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {

    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        
        guard let password = passwordOutlet.text,
            let email = emailOutlet.text,
            email != "",
            password != "" else {shake(); return}
        
        
        
        UserController.shared.logInUser(email: email, password: password) { (success) in
            
            if success {
                DispatchQueue.main.async {
                    self.passwordOutlet.resignFirstResponder()
                    NotificationCenter.default.post(name: .signInTapped, object: nil)
                    self.performSegue(withIdentifier: "toMapViewBaby", sender: self)
                }
            } else {

               self.shake()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func blurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = self.blurView.bounds
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        self.blurView.addSubview(visualEffectView)
    }
}

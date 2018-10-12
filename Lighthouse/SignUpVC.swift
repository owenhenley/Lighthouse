//
//  SignUpVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import AudioToolbox

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var signUpConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserController.shared.user != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.signUpConstraint.constant = 308 // keyboard is 258px (258+50)
            self.view.layoutIfNeeded() // view version of '.reloaddata()'
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func createProfileTapped(_ sender: Any) {
        guard let email = emailOutlet.text,
            let password = passwordOutlet.text,
            let username = usernameOutlet.text else {return}
        UserController.shared.createUser(username: username, email: email, password: password) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.shake()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.view.center = CGPoint(x: 0.5 * self.view.frame.width, y: -self.view.frame.height)
        }
    }
}

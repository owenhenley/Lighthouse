//
//  SignUpVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import AudioToolbox
import SVProgressHUD

class SignUpVC: CustomTextFieldVC {
    
        // MARK: - Outlets
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var signUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    
    
        // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurBackground()
        usernameOutlet.delegate = self
        textFields = [emailOutlet, passwordOutlet, usernameOutlet]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AUTH.currentUser != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createProfileTapped(self)
        return true
    }
    
    
        // MARK: - Actions

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .backButtonTapped, object: nil)
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        UIView.animate(withDuration: 0.5) {
//            self.signUpConstraint.constant = 308 // keyboard is 258px (258+50)
//            self.view.layoutIfNeeded() // view version of '.reloaddata()'
//        }
//    }
//
    func blurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = self.blurView.bounds
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        self.blurView.addSubview(visualEffectView)
    }
    
    
    @IBAction func createProfileTapped(_ sender: Any) {
        SVProgressHUD.show()
        guard let email = emailOutlet.text,
            let password = passwordOutlet.text,
            let username = usernameOutlet.text else {return}
        UserController.shared.createUser(username: username, email: email, password: password) { (success) in
            if success {
                NotificationCenter.default.post(name: .signInTapped, object: nil)
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.dismiss()
            } else {
                self.shake()
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.view.center = CGPoint(x: 0.5 * self.view.frame.width, y: -self.view.frame.height)
        }
    }
}

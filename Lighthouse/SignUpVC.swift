//
//  SignUpVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpVC: CustomTextFieldVC {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailOutlet      : UITextField!
    @IBOutlet weak var passwordOutlet   : UITextField!
    @IBOutlet weak var usernameOutlet   : UITextField!
    @IBOutlet weak var signUpConstraint : NSLayoutConstraint!
    @IBOutlet weak var blurView         : UIView!
    @IBOutlet weak var termsButton      : UIButton!
    
    
    // MARK: - Propeties
    
    var termsToggled = false
    
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
    
    
    @IBAction func termsToggled(_ sender: UIButton) {
        
        if termsToggled == false {
            termsToggled = true
            termsButton.setImage(UIImage(named: "checkmarkDark"), for: .normal)
        } else {
            termsToggled = false
            termsButton.setImage(nil, for: .normal)
        }
        
    }
    
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        
        guard let privacyURL = URL(string: "https://www.apple.com") else { return }
        
        UIApplication.shared.open(privacyURL) { (_) in
        }
    }
    
    
    @IBAction func tAndCsTapped(_ sender: UIButton) {
        guard let privacyURL = URL(string: "https://www.apple.com") else { return }
        
        UIApplication.shared.open(privacyURL) { (_) in
        }
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .backButtonTapped, object: nil)
    }
    
    
    @IBAction func createProfileTapped(_ sender: Any) {
        
        if termsToggled == true {
            
            SVProgressHUD.show()
            guard let email = emailOutlet.text,
                let password = passwordOutlet.text,
                let name = usernameOutlet.text else {return}
            UserController.shared.createUser(name: name, email: email, password: password) { (success) in
                if success {
                    NotificationCenter.default.post(name: .signInTapped, object: nil)
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                } else {
                    self.shake()
                    SVProgressHUD.dismiss()
                }
            }
        } else {
            print("Didntt aggree")
        }
    }
    
    
    
    @IBAction func signInTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.view.center = CGPoint(x: 0.5 * self.view.frame.width, y: -self.view.frame.height)
        }
    }
    
    
    func blurBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = self.blurView.bounds
        visualEffectView.translatesAutoresizingMaskIntoConstraints = true
        self.blurView.addSubview(visualEffectView)
    }
}

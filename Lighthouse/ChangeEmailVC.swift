//
//  ChangeEmailVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/12/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChangeEmailVC: UIViewController {
    
    
    @IBOutlet weak var signInEmailTF    : UITextField!
    @IBOutlet weak var signInPasswordTF : UITextField!
    @IBOutlet weak var signInStack      : UIStackView!
    
    @IBOutlet weak var changeEmailTF1   : UITextField!
    @IBOutlet weak var changeEmailTF2   : UITextField!
    @IBOutlet weak var updateStack      : UIStackView!
    
    
    // MARK: - Proerties
    
    let user = AUTH.currentUser
    var credential: AuthCredential?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        resetEmail()
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        reAuthenticate()
    }
    
    
    func reAuthenticate() {
        SVProgressHUD.show()
        
        guard let email = signInEmailTF.text, !email.isEmpty, let password = signInPasswordTF.text, !password.isEmpty else { return }
        
        credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        guard let credential = credential else { return }
        
        user?.reauthenticateAndRetrieveData(with: credential, completion: { (results, error) in
            if let error = error {
                debugPrint("❌ Error in file \(#file), function \(#function), \(error),\(error.localizedDescription)❌")
                SVProgressHUD.dismiss()
            } else {
                print("User ReAuthenticated")
                SVProgressHUD.dismiss()
            }
            self.signInStack.isHidden = true
            self.updateStack.isHidden = false
        })
    }
    
    
    
    func resetEmail() {
        SVProgressHUD.show()
        
        guard changeEmailTF2.text == changeEmailTF1.text else {
            shake()
            print("Emails NOT the same")
            return
        }
        
        guard let newEmail = changeEmailTF2.text, !newEmail.isEmpty else { return }
        
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                debugPrint("❌ Error in file \(#file), function \(#function), \(error),\(error.localizedDescription)❌")
                SVProgressHUD.dismiss()
            }
            
            guard let user = UserController.shared.user else { return }
            
            user.email = newEmail
            
            UserController.shared.updateUser(user: user, completion: { (_) in
            })
            self.performSegue(withIdentifier: "returnToUserProfile", sender: self)
            SVProgressHUD.dismiss()
        })
    }
}



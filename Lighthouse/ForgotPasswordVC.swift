//
//  ForgotPasswordVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    // Send an email to the users email address to reset their password.
    @IBAction func resetTapped(_ sender: UIButton) {
        
        guard let email = emailTF.text, !email.isEmpty else { return }
        
        // FIXME: Add completion to check when email sent, user activity monitor wheel, show alerts when completed.
        self.dismiss(animated: true, completion: nil)

        AUTH.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint("❌ Error in file \(#file), function \(#function), \(error),\(error.localizedDescription)❌")
                //FIXME: Can't find email, double check the address
            } else {
                print("Password reset link Sent! ✅")
                //FIXME: Remind user to check junk/spam.
            }
        }
    }
    
}

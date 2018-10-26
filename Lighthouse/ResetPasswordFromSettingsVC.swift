//
//  ResetPasswordFromSettingsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/12/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class ResetPasswordFromSettingsVC: UIViewController {
    
        // MARK: - Outlets
    
    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        resetPassword()
    }
    
    func resetPassword() {
        SVProgressHUD.show()
        
        guard let email = emailTF.text, !email.isEmpty else { return }
        
        AUTH.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                #warning("Show email doesnt not exist warning")
                debugPrint("❌ Error in file \(#file), function \(#function), \(error),\(error.localizedDescription)❌")
                SVProgressHUD.dismiss()
                self.shake()
                self.emailTF.resignFirstResponder()
                return
            }
            
          self.performSegue(withIdentifier: "returnToUserProfile", sender: self)
            SVProgressHUD.dismiss()
        }
    }
}

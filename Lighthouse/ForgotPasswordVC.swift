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
    
        // MARK: - Variables
    
    
        // MARK: - Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
        // MARK: - Actions

    @IBAction func resetTapped(_ sender: UIButton) {
        
        guard let email = emailTF.text, !email.isEmpty else { return }
        
        AUTH.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint("❌ Error in file \(#file), function \(#function), \(error),\(error.localizedDescription)❌")
            } else {
                print("Password reset link Sent! ✅")
            }
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

}

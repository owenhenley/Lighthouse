//
//  SignUpVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        UserController.shared.createUser(username: username, email: email, password: password)
    }
    
}

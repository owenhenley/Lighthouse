//
//  DeleteAccountVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/12/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class DeleteAccountVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textField: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self

        let dismissGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissGuesture)
    }
    
    @objc func dismissKeyboard(){
        textField.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        dismissKeyboard()
        return true
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteAcountTapped(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Are you sure you want to delete your acount?", message: "This action cannot be undone", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Yes", style: .default) { (_) in
            UserController.shared.deleteUser(completion: { (success) in
                if success {
                    UserController.shared.user = nil
                    FriendController.shared.friends = []
                    let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
                    let mainView = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                    mainView.tabBarController?.tabBar.isHidden = false
                    self.dismiss(animated: true, completion: nil)
                    self.present(mainView, animated: true, completion: nil)
                    
                } else {
                    let errorAlert = UIAlertController(title: "Our Bad", message: "We're experiencing some functionality issues with deleting your acount, in order to delete this acount please email us at support@lighthouse.com", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Return to settings", style: .default, handler: { (_) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    errorAlert.addAction(action)
                    self.present(errorAlert, animated: true)
                    
                }
            })
        }
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        deleteAlert.addAction(okay)
        deleteAlert.addAction(no)
        self.present(deleteAlert, animated: true)
    }
    

}

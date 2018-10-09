//
//  AlertControllers.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 08/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

//extension UIViewController {
//    let locationAlertController = UIAlertController(title: "Lighthouse needs to use your location", message: <#T##String?#>, preferredStyle: <#T##UIAlertController.Style#>)
//}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

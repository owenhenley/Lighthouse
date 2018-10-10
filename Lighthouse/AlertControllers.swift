//
//  AlertControllers.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 08/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(picker: UIImagePickerController){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (completion) in
            picker.sourceType = .camera
            self.present(picker, animated: true)
        }
        let photoAction = UIAlertAction(title: "Library", style: .default) { (completion) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
//        picker.delegate = self
        picker.allowsEditing = true
        self.present(alertController, animated: true)
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

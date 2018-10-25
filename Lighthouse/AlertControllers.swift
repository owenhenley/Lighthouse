//
//  AlertControllers.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 08/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import AVFoundation


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(picker: UIImagePickerController){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (completion) in
            
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
        switch authorizationStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    if granted {
                        picker.sourceType = .camera
                        self.present(picker, animated: true)
                        print("access granted")
                    }
                    else {
                        print("access denied")
                    }
                }
            case .authorized:
                print("Access authorized")
                picker.sourceType = .camera
                self.present(picker, animated: true)
            case .denied, .restricted:
                //FIXME: Bring user to camera settings
                print("restricted")
                
            }
            
            
        }
        let photoAction = UIAlertAction(title: "Library", style: .default) { (completion) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        picker.allowsEditing = true
        self.present(alertController, animated: true)
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension UITableViewController {
    func setupTableView() {
        let nib = UINib(nibName: "FriendCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendCell")
    }
}

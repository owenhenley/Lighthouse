//
//  Animations.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 11/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit


extension UIViewController {
    func shake(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0.09, options: [], animations: {
            self.view.center = CGPoint(x: 0.508 * self.view.frame.width, y: 0.5 * self.view.frame.height)
        }, completion: { (done) in
            if done {
                self.view.center = CGPoint(x: 0.5 * self.view.frame.width, y: 0.5 * self.view.frame.height)
            }
        })
    }
    
    func spin(view: UIView){
        UIView.animate(withDuration: 1) {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * -0.999999))
        }
    }
    
    func spinBack(view: UIView){
        UIView.animate(withDuration: 1) {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * -0.999999))
        }
    }
    
}



class CustomSearchFieldVC: UIViewController, UISearchBarDelegate{
    var searchField: UISearchBar?
    func dissmisskeyBoard(){
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handlePan(){
        searchField?.resignFirstResponder()
    }

}

class CustomTextFieldVC: UIViewController, UITextFieldDelegate{
    
    var textFields: [UITextField] = []
    
    
    
    func dissmisskeyBoard(){
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handlePan(){
        textFields.forEach{$0.resignFirstResponder()}
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        dissmisskeyBoard()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {

            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
    }
}



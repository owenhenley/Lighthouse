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



//
//  CustomButtons.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/23/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit


@IBDesignable
class BorderTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}


@IBDesignable
class CornerRadius: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
}

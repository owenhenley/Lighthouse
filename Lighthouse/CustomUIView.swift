//
//  CustomUIView.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/23/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

@IBDesignable class CustomPopover: UIView {
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        customisePopover()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customisePopover()
    }
    
    
    func customisePopover(){
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
}


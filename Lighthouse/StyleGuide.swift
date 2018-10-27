//
//  StyleGuide.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/15/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

    // MARK: - Colour

extension UIColor {
    
    @nonobjc class var lightNavy: UIColor {
        return UIColor(red: 17.0 / 255.0, green: 37.0 / 255.0, blue: 103.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var pumpkinOrange: UIColor {
        return UIColor(red: 1.0, green: 129.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0)
    }
    
        // MARK: - ✅ PRIMARY COLOR ✅
    
    @nonobjc class var orange: UIColor {
        return UIColor(red: 232.0 / 255.0, green: 117.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleOrange: UIColor {
        return UIColor(red: 1.0, green: 169.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lavenderBlue: UIColor {
        return UIColor(red: 119.0 / 255.0, green: 150.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var denim: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 75.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var blueBlue: UIColor {
        return UIColor(red: 34.0 / 255.0, green: 73.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var rustyOrange: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 103.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greyishBrown: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var dirtBrown: UIColor {
        return UIColor(red: 127.0 / 255.0, green: 84.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var cocoa30: UIColor {
        return UIColor(red: 118.0 / 255.0, green: 80.0 / 255.0, blue: 67.0 / 255.0, alpha: 0.3)
    }
    
    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 155.0 / 255.0, alpha: 1.0)
    }
    
}

    // MARK: - TypeFace

extension UIFont {
    
    class var brandName: UIFont {
        return UIFont(name: "Megrim", size: 40.0)!
    }
    
    class var copyHeadline: UIFont {
        return UIFont(name: "Helvetica-Light", size: 30.0)!
    }
    
    class var friendDrawerName: UIFont {
        return UIFont(name: "Helvetica", size: 16.0)!
    }
    
    class var copyBody: UIFont {
        return UIFont(name: "Helvetica-Light", size: 16.0)!
    }
    
    class var friendDrawerLocation: UIFont {
        return UIFont(name: "Helvetica-Light", size: 12.0)!
    }
    
    class var friendDrawerDistanceActive: UIFont {
        return UIFont(name: "Helvetica", size: 12.0)!
    }
    
    class var friendDrawerDistanceNormal: UIFont {
        return UIFont(name: "Helvetica", size: 12.0)!
    }
    
    class var buttonContainedButton: UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: 12.0)!
    }
    
    class var buttonTextButton: UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: 12.0)!
    }
    
    class var friendLocation: UIFont {
        return UIFont(name: "Helvetica", size: 12.0)!
    }
    
}

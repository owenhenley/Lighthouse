//
//  CustomExitSegueWithCompletion.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/26/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class CustomExitSegueWithCompletion: UIStoryboardSegue {
    var completion: (() -> Void)?
    
    override func perform() {
        super.perform()
        if let completion = completion {
            completion()
        }
    }
}

//
//  DateFormatter.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/5/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import Foundation

extension Date {
    
    func dateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

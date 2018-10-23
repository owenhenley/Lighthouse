//
//  PendingPendingCell.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class PendingPendingCell: UITableViewCell {
    
        // MARK: - Outlets

    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var friendName   : UILabel!
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!
    
    
        // MARK: - Actions
    
    @IBAction func acceptTapped(_ sender: Any) {
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
    }
    
}
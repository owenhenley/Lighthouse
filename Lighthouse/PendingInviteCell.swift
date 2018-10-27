//
//  PendingPendingCell.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit



protocol PendingCellInteractableDelegate: class {
    func buttonTapped(sender: PendingInviteCell, indexPath: IndexPath?)
//    func removeRequestTapped()
}

class PendingInviteCell: UITableViewCell {
    
        // MARK: - Outlets

    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var friendName   : UILabel!
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!
    
    weak var delegate: PendingCellInteractableDelegate?
    var indexPath: IndexPath?
    
        // MARK: - Actions
    
    @IBAction func acceptTapped(_ sender: Any) {
        delegate?.buttonTapped(sender: self, indexPath: indexPath)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
//        delegate?.removeRequestTapped()
    }
    
    
    func updateViews() {
        // if accepted, remove and reload data
        // if removed, remove and reload data
    }
    
}

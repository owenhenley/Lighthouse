//
//  SelectFriendCell.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/19/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit


class SelectFriendCell: UITableViewCell {
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var activityStatusOutlet: UILabel!
    @IBOutlet weak var imageOverlayOutlet: UIView!
    
//    weak var delegate: FriendSelectable?
    
    var friendID: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectFriendTapped(_ sender: Any) {
//        delegate?.selectFriend(cell: self)
    }
    
}

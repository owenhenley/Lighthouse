//
//  FriendsListTrayCell.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsListTrayCell: UITableViewCell {
    
        // MARK: - Outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendLocationLabel: UILabel!
    
    
        // MARK: - Variables
    
    var friend: Friend?
    
    
//    func updateViews() {
//        guard var profileImage = profileImage.image,
//        var friendName = friendNameLabel.text,
//            var friendLocation = friendLocationLabel.text else { return }
//
//        profileImage = #imageLiteral(resourceName: "Jim")
//        friendName = friend?.friendName.shuffled()
//        friendLocation = friend?.friendLocation.shuffled()
//    }
}

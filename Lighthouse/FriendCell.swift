//
//  SearchCell.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 15/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit



class FriendCell: UITableViewCell {
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var subTitleOutlet: UILabel!
    @IBOutlet weak var activeIcon: UIImageView!
    
    


    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    
}

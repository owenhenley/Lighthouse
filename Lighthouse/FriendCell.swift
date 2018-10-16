//
//  SearchCell.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 15/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

protocol RequestTableViewCellDelegate: class {
    func buttonTapped(sender: FriendCell)
}

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var subTitleOutlet: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    

    weak var delegate: RequestTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.buttonTapped(sender: self)
        
    }
    
}

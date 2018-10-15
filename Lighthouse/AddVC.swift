//
//  AddVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class AddVC: UITableViewController, UISearchBarDelegate, RequestTableViewCellDelegate {
    
    

    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: FriendController.shared.resultsUpdated, object: nil)

    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FriendController.shared.results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as? SearchCell
        

        cell?.delegate = self
        let friend = FriendController.shared.results[indexPath.row]
        self.friend = friend
        switch friend.request {
        case true:
            cell?.buttonOutlet.setTitle("Pending", for: .normal)
        case false:
            cell?.buttonOutlet.setTitle("Accept", for: .normal)
        default:
            cell?.buttonOutlet.setTitle("Add Friend", for: .normal)
        }
        
        cell?.titleOutlet.text = friend.username
        
        if friend.imageUrl == "No Profile Image" {
            cell?.imageOutlet.isHidden = true
        } else {
            cell?.imageOutlet.isHidden = false
            FriendController.shared.fetchFreindsImage(urlString: friend.imageUrl) { (image) in
                DispatchQueue.main.async {
                    cell?.imageOutlet.image = image
                }
            }
            
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    
    func buttonTapped(sender: SearchCell) {
        let friendID = friend!.friendID
        switch friend?.request {
        case false:
            FriendController.shared.acceptRequest(friendID: friendID)
            sender.buttonOutlet.isHidden = true
            
            
        case true:
            FriendController.shared.cancelRequest(friendID: friendID)
            sender.buttonOutlet.setTitle("Add Friend", for: .normal)
            friend?.request = nil

        default:
            FriendController.shared.requestFriend(friendID: friendID)
            sender.buttonOutlet.setTitle("Pending", for: .normal)
            friend?.request = true

        }
        

        
    }
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


}

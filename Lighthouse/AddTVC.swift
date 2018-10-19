//
//  AddVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class AddTVC: UITableViewController, UISearchBarDelegate, RequestTableViewCellDelegate {
    
    

    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .resultsUpdated, object: nil)
        
        setupTableView()

    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let grandpa = parent?.parent as? FriendsListSuperView else {return}
        grandpa.searchBar.resignFirstResponder()
    }

    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if FriendController.shared.results.isEmpty {
            return FriendController.shared.pendingReuests.count
        } else {
            return FriendController.shared.results.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        cell?.delegate = self
        cell?.indexPath = indexPath
        if FriendController.shared.results.isEmpty {
            friend = FriendController.shared.pendingReuests[indexPath.row]
        } else {
            friend = FriendController.shared.results[indexPath.row]
        }
        guard let friend = self.friend else {return UITableViewCell()}
        
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
            FriendController.shared.fetchFriendsImage(urlString: friend.imageUrl) { (image) in
                DispatchQueue.main.async {
                    cell?.imageOutlet.image = image
                }
            }
            
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    
    func buttonTapped(sender: FriendCell, indexPath: IndexPath?) {
        let friendID = friend!.friendID
        switch friend?.request {
        case false:
            FriendController.shared.acceptRequest(friend: friend!)
            FriendController.shared.pendingReuests.remove(at: indexPath!.row)
            tableView.reloadData()
        
            
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



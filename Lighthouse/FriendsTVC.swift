//
//  FriendsVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTVC: UITableViewController, RequestTableViewCellDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: FriendController.shared.friendsUpdated, object: nil)
        
    }
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friends.count
    }
    
    // These functions resign the text field on the super view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resignParentResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resignParentResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        resignParentResponder()
    }
    
    
    func resignParentResponder(){
        guard let grandpa = parent?.parent as? FriendsListSuperView else {return}
        grandpa.searchBar.resignFirstResponder()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        cell?.delegate = self
        let friend = FriendController.shared.friends[indexPath.row]
        self.indexPath = indexPath

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
    var indexPath: IndexPath?
    func buttonTapped(sender: FriendCell, indexPath: IndexPath?) {
        guard let indexPath = indexPath else {return}
        let friend = FriendController.shared.friends[indexPath.row]
        FriendController.shared.deleteFriend(friendID: friend.friendID)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.reloadData()

    }
    
}

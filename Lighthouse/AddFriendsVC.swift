//
//  AddFriendsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class AddFriendsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var friend: Friend?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .resultsUpdated, object: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteFriendsTapped(_ sender: UIButton) {
        
        let message = "Hey! I got this new free app 'Lighthouse', lets hang out!"
        let appStoreLink = "AppStore link coming soon."
        
        let messageToShare = [message, appStoreLink]
        let shareAlert = UIActivityViewController(activityItems: messageToShare, applicationActivities: nil)
        
        shareAlert.popoverPresentationController?.sourceView = sender
        present(shareAlert, animated: true, completion: nil)
    }
    
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func friendRequestTapped() {
        
        guard let friendID = friend?.friendID else { return }
        
//        switch friend?.request {
//        case false:
//            FriendController.shared.acceptRequest(friend: friend)
//            FriendController.shared.pendingReuests.remove(at: indexPath.row)
//            tableView.reloadData()
//
//
//        case true:
//            FriendController.shared.cancelRequest(friendID: friendID)
//            sender.buttonOutlet.setTitle("Add Friend", for: .normal)
//            friend?.request = nil
//
//        default:
//            FriendController.shared.requestFriend(friendID: friendID)
//            sender.buttonOutlet.setTitle("Pending", for: .normal)
//            friend?.request = true
//
        }
//    }
    
}

extension AddFriendsVC: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if FriendController.shared.results.isEmpty {
            return FriendController.shared.pendingReuests.count
        } else {
            return FriendController.shared.results.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendPendingCell", for: indexPath) as? PendingInviteCell
        
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}

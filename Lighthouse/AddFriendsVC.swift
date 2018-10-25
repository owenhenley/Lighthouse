//
//  AddFriendsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class AddFriendsVC: CustomSearchFieldVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var friend: Friend?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .resultsUpdated, object: nil)
        setUpKeyboardDissmiss()
    }
    
    func setUpKeyboardDissmiss() {
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func handlePanGesture() {
        searchBar.resignFirstResponder()
    }


    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteFriendsTapped(_ sender: UIButton) {
        
        let message = "Hey! I just got this app ‘Lighthouse’ - it makes it super easy to find and meet up with your friends. Check it out -"
        let appStoreLink = "(AppStore link coming soon.)"
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {return}
        FriendController.shared.searchFriends(text: text) { (success) in
            self.updateViews()
        }
    }
    
//    func friendRequestTapped() {
//
//        guard let friendID = friend?.friendID else { return }
    
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
//        }
//    }
    
}

extension AddFriendsVC: UITableViewDataSource, UITableViewDelegate, PendingCellInteractableDelegate {
    
    
    //MARK: UITableViewDataSource
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if FriendController.shared.results.isEmpty {
//            return FriendController.shared.pendingReuests.count
//        } else {
//            return FriendController.shared.results.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "friendPendingCell", for: indexPath) as? PendingInviteCell
//        let friend = FriendController.shared.friends[indexPath.row]
//        cell?.friendName.text = friend.name
//        fetchImageWithUrlString(urlString: friend.imageUrl) { (image) in
//            DispatchQueue.main.async {
//                cell?.profileImage.image = image
//            }
//        }
//        return cell ?? UITableViewCell()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if FriendController.shared.results.isEmpty {
            return FriendController.shared.pendingReuests.count
        } else {
            return FriendController.shared.results.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingFriendCell", for: indexPath) as? PendingInviteCell
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
            cell?.acceptButton.setTitle("Pending", for: .normal)
        case false:
            cell?.acceptButton.setTitle("Accept", for: .normal)
        default:
            cell?.acceptButton.setTitle("Add Friend", for: .normal)
        }
        
        cell?.friendName.text = friend.name
        
        if friend.imageUrl == "No Profile Image" {
            cell?.profileImage.isHidden = true
        } else {
            cell?.profileImage.isHidden = false
            fetchImageWithUrlString(urlString: friend.imageUrl) { (image) in
                DispatchQueue.main.async {
                    cell?.profileImage.image = image
                }
            }
            
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func buttonTapped(sender: PendingInviteCell, indexPath: IndexPath?) {
        let friendID = friend!.friendID
        switch friend?.request {
        case false:
            FriendController.shared.acceptRequest(friend: friend!)
            FriendController.shared.pendingReuests.remove(at: indexPath!.row)
            tableView.reloadData()
            
            
        case true:
            FriendController.shared.cancelRequest(friendID: friendID)
            sender.acceptButton.setTitle("Add Friend", for: .normal)
            friend?.request = nil
            
        default:
            FriendController.shared.requestFriend(friendID: friendID)
            sender.acceptButton.setTitle("Pending", for: .normal)
            friend?.request = true
            
        }
        
        
        
    }
    
    
}

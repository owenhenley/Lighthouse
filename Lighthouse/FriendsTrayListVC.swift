//
//  FriendsTrayListVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTrayListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let shared = FriendsTrayListVC()
    
    @IBOutlet weak var friendsTableView : UITableView!
    @IBOutlet weak var getStartedView   : UIView!
    @IBOutlet weak var searchBar        : UISearchBar!
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        getStartedView.isHidden = true
        //        friendsTableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .friendsUpdated, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If has friends, show get started + hide tableView, else show populated tableView.
//        friendsTableView.reloadData()
        
        if FriendController.shared.friends.count == 0 {
            getStartedView.isHidden = false
            friendsTableView.isHidden = true
            searchBar.isHidden = true
        } else if FriendController.shared.friends.count > 0 {
            getStartedView.isHidden = true
            friendsTableView.isHidden = false
            searchBar.isHidden = false
        }
    }
    
    
    // Reload tableview when friends list gets fetched or updated
    @objc func reloadTableView() {
        friendsTableView.isHidden = false
        getStartedView.isHidden = true
        friendsTableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friends.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendTrayCell", for: indexPath) as? FriendsListTrayCell
        
        let friend = FriendController.shared.friends[indexPath.row]
        cell?.friendID = friend.friendID
        
        if friend.image == nil {
            if friend.imageUrl == "No Profile Image" {
                cell?.profileImage.image = UIImage(named: "defaultProfPic")
            } else {
                fetchImageWithUrlString(urlString: friend.imageUrl) { (profileImage) in
                    DispatchQueue.main.async {
                        cell?.profileImage.image = profileImage
                        FriendController.shared.friends[indexPath.row].image = profileImage
                    }
                }
            }
        }
        
        cell?.friendNameLabel.text = friend.name
        cell?.friendLocationLabel.text = "needs filling"
        
        return cell ?? UITableViewCell()
    }
}

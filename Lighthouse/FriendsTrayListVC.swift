//
//  FriendsTrayListVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTrayListVC: CustomSearchFieldVC, UITableViewDataSource, UITableViewDelegate {
    
    static let shared = FriendsTrayListVC()
    
    @IBOutlet weak var friendsTableView : UITableView!
    @IBOutlet weak var getStartedView   : UIView!
    @IBOutlet weak var searchBar        : UISearchBar!
    
    //MARK: - Variables
    
    var searchFriends: [Friend] = []
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        getStartedView.isHidden = true
        searchBar.delegate = self
        //        friendsTableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .friendsUpdated, object: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If has friends, show get started + hide tableView, else show populated tableView.
//        friendsTableView.reloadData()
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        self.searchFriends = FriendController.shared.friends.filter{$0.name.lowercased().contains(searchText.lowercased())}
        friendsTableView.reloadData()
    }
    
    
    // Reload tableview when friends list gets fetched or updated
    @objc func reloadTableView() {
        if FriendController.shared.friends.count == 0 {
            getStartedView.isHidden = false
            friendsTableView.isHidden = true
            searchBar.isHidden = true
        } else {
            getStartedView.isHidden = true
            friendsTableView.isHidden = false
            searchBar.isHidden = false
        }
        friendsTableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar.text != "" {
            return searchFriends.count
        }
        return FriendController.shared.friends.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendTrayCell", for: indexPath) as? FriendsListTrayCell
        
        var friend: Friend!
        if !searchFriends.isEmpty {
            friend = searchFriends[indexPath.row]
        } else {
            friend = FriendController.shared.friends[indexPath.row]
        }
        
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

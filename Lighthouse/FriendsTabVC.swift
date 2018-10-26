//
//  FriendsTabVC.swift
//  Lighthouse
//
//  Created by Owen Henley & Levi Linchenko on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTabVC: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    
    
    // MARK: - Properties
    
    var indexPath   : IndexPath?
    var searchField : UISearchBar?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        searchBar.delegate   = self
        
        searchField = searchBar
        addButton.imageView?.contentMode = .scaleAspectFit
        
        dissmisskeyBoard()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .friendsUpdated, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
    // MARK: - Notification Center
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func buttonTapped(sender: FriendCell, indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let friend = FriendController.shared.friends[indexPath.row]
        FriendController.shared.deleteFriend(friendID: friend.friendID)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.reloadData()
    }
    
    var searchFriends: [Friend] = []

}


// MARK: - Search Bar Methods

extension FriendsTabVC: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        self.searchFriends = FriendController.shared.friends.filter{$0.name.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func dissmisskeyBoard() {
        let tap = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func handlePan() {
        searchField?.resignFirstResponder()
    }
}


extension FriendsTabVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchText = searchBar.text else { return 0}

        if searchText == "" {
            return FriendController.shared.friends.count
        }
        return searchFriends.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        
//        cell?.delegate = self
        var friend: Friend!
        
        if searchFriends.isEmpty {
            friend = FriendController.shared.friends[indexPath.row]
        } else {
            friend = searchFriends[indexPath.row]
        }
        
        if let event = EventController.shared.events[friend.friendID] {
            cell?.activeIcon.isHidden = false
            cell?.subTitleOutlet.text = event.eventTitle
            cell?.subTitleOutlet.font = UIFont.systemFont(ofSize: 16)
            
        } else {
            cell?.activeIcon.isHidden = true
            cell?.subTitleOutlet.font = UIFont.italicSystemFont(ofSize: 16)
            cell?.subTitleOutlet.text = "inactive"
        }
        
        self.indexPath = indexPath
        
        cell?.titleOutlet.text = friend.name
        
        if friend.imageUrl == "No Profile Image" {
            cell?.imageOutlet.isHidden = true
        } else {
            cell?.imageOutlet.isHidden = false
            fetchImageWithUrlString(urlString: friend.imageUrl) { (image) in
                DispatchQueue.main.async {
                    cell?.imageOutlet.image = image
                }
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    
    func setupTableView() {
        let nib = UINib(nibName: "FriendCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendCell")
    }
}

//
//  FriendsTabVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTabVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var indexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .friendsUpdated, object: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resignParentResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        resignParentResponder()
    }
    
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func resignParentResponder(){
        guard let superView = parent?.parent as? FriendsListSuperView else {return}
        superView.searchBar.resignFirstResponder()
    }
    
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friends.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        cell?.delegate = self
        let friend = FriendController.shared.friends[indexPath.row]
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func setupTableView() {
        let nib = UINib(nibName: "FriendCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FriendCell")
    }
}

extension FriendsTabVC: RequestTableViewCellDelegate {
    
    func buttonTapped(sender: FriendCell, indexPath: IndexPath?) {
        guard let indexPath = indexPath else {return}
        let friend = FriendController.shared.friends[indexPath.row]
        FriendController.shared.deleteFriend(friendID: friend.friendID)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.reloadData()
    }
}

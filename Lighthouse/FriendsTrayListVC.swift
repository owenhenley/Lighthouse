//
//  FriendsTrayListVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTrayListVC: UIViewController {
    
    static let shared = FriendsTrayListVC()
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var getStartedView: UIView!
    
    
        // MARK: - Variables
    
    // MOCK DATA
//    var friendName = ["Jim Halpert", "Hugo Bean", "Lola Henley", "Pam Beasley", "Creed Bratton"]
//    var friendLocation = ["J-Dawgs","Jimmy Johns", "Robins Nest", "Apollo", "Apple"]
//    var friendImage = [UIImage(named: "Jim"), #imageLiteral(resourceName: "hugo"), #imageLiteral(resourceName: "lola"), #imageLiteral(resourceName: "pam"), #imageLiteral(resourceName: "creed")]
    
    
        // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        getStartedView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // If has friends, show get started + hide tableView, else show populated tableView.
    }
    
    
        // MARK: - Actions
    
}


extension FriendsTrayListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friends.count
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendsListTrayCell
        
        
        // If user had no friends, Hide TableView, show "Find Friends View"
        
        let friend = FriendController.shared.friends[indexPath.row]
        
        cell?.friendNameLabel.text = friend.name
//        cell?.friendLocationLabel.text = friend.
        
        if friend.imageUrl == "No Profile Image" {
            cell?.profileImage.image = UIImage(named: "defaultProfPic")
        } else {
            FriendController.shared.fetchFriendsImage(urlString: friend.imageUrl) { (image) in
                DispatchQueue.main.async {
                    cell?.profileImage.image = image
                }
            }
        }
        
//        let friendRealName = friendName[indexPath.row]
//        let FriendLocation = friendLocation[indexPath.row]
//        let images = friendImage[indexPath.row]
        
//        cell?.profileImage.image = images
//        cell?.friendNameLabel.text = friendRealName
//        cell?.friendLocationLabel.text = FriendLocation
        
        
        return cell ?? UITableViewCell()
    }
    
}

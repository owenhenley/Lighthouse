//
//  FriendsTrayListVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/9/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

protocol FriendsInTrayShown: class {
    func trayOpened()
}

class FriendsTrayListVC: UIViewController {
    
    static let shared = FriendsTrayListVC()
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    
        // MARK: - Variables
    
    weak var delegate: FriendsInTrayShown?
    var mapVC: MapViewVC!
    
//    var friendName = ["Jim Halpert", "Hugo Bean", "Lola Henley", "Pam Beasley", "Creed Bratton"]
//    var friendLocation = ["J-Dawgs","Jimmy Johns", "Robins Nest", "Apollo", "Apple"]
    
    
        // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        mapVC = parent as? MapViewVC
//        self.delegate = mapVC
    }
    
        // MARK: - Actions
    
}


extension FriendsTrayListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendsListTrayCell
        
//        let friend = friendName[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
    
}

//
//  AddVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class AddVC: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FriendController.shared.results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let friend = FriendController.shared.results[indexPath.row]
        cell.textLabel?.text = friend.username
        
        return cell
    }
    
    func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


}

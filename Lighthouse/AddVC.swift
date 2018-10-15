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
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: FriendController.shared.resultsUpdated, object: nil)

    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FriendController.shared.results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as? SearchCell

        let friend = FriendController.shared.results[indexPath.row]
        
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
    
    @objc func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


}

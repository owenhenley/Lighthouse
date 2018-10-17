//
//  FriendsVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class FriendsTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }

    // MARK: - Table view data source


    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resignParentResponder()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return FriendController.shared.friends.count
        return 4

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resignParentResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        resignParentResponder()
    }
    
    
    func resignParentResponder(){
        guard let grandpa = parent?.parent as? FriendsListSuperView else {return}
        grandpa.searchBar.resignFirstResponder()
    }
    //MocData

    var images = [#imageLiteral(resourceName: "Jim"),#imageLiteral(resourceName: "pam"), #imageLiteral(resourceName: "hugo"), #imageLiteral(resourceName: "lola") ]
    var name = ["Jame Halpert", "Pam", "Hound", "Mutt"]
    var locations = ["jimmyBoy", "housewifer3", "daawwwg", "carpterPooer"]

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
        cell?.imageOutlet.image = images[indexPath.row]
        cell?.titleOutlet.text = name[indexPath.row]
        cell?.subTitleOutlet.text = locations[indexPath.row]
        cell?.buttonOutlet.isHidden = true
        return cell ?? UITableViewCell()
        
    }
    // Real Function
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell
//        let friend = FriendController.shared.friends[indexPath.row]
//
//        cell?.titleOutlet.text = friend.username
//
//        if friend.imageUrl == "No Profile Image" {
//            cell?.imageOutlet.isHidden = true
//        } else {
//            cell?.imageOutlet.isHidden = false
//            FriendController.shared.fetchFreindsImage(urlString: friend.imageUrl) { (image) in
//                DispatchQueue.main.async {
//                    cell?.imageOutlet.image = image
//                }
//            }
//
//        }
//
//        return cell ?? UITableViewCell()
//    }
//

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

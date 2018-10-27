//
//  SelectFriendsVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 10/18/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit
import SVProgressHUD

class SelectFriendsVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var event: Event?
    var friendIDs: [Int:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        print("back tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareTapped(_ sender: Any) {
        SVProgressHUD.show()
        guard let event = event else { return }
        let friendIDS: [String] = friendIDs.compactMap{$0.value}
        EventController.shared.uploadEvent(event: event, friendIDs: friendIDS) { (true) in
            if true {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToMapFromPin", sender: self)
                }
            }
        }
        print("Shared")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMapFromPin"{
            let mapView = segue.destination as? MapViewVC
            mapView?.fromShareScreen = true
        }
    }
}


extension SelectFriendsVC: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectFriendCell", for: indexPath) as? SelectFriendCell
        
        let friend = FriendController.shared.friends[indexPath.row]
        cell?.friendID = friend.friendID

        if friend.image == nil {
            if friend.imageUrl == "No Profile Image" {
                cell?.imageOutlet.image = UIImage(named: "defaultProfPic")
            } else {
                fetchImageWithUrlString(urlString: friend.imageUrl) { (image) in
                    DispatchQueue.main.async {
                        cell?.imageOutlet.image = image
                        FriendController.shared.friends[indexPath.row].image = image
                    }
                }
            }
            
        } else {
            cell?.imageOutlet.image = friend.image
        }
        
        cell?.nameOutlet.text = friend.name
        cell?.activityStatusOutlet.text = friend.event?.streetAddress ?? "Inactive"
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFriend(indexPath: indexPath)
    }
    
    
    func selectFriend(indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let cell = tableView.cellForRow(at: indexPath) as? SelectFriendCell
        guard let friendID = cell?.friendID else {return}
        if cell?.imageOverlayOutlet.isHidden == true {
            self.friendIDs.updateValue(friendID, forKey: indexPath.row)
            cell?.imageOverlayOutlet.isHidden = false
            cell?.imageOverlayOutlet.backgroundColor = .black
            cell?.imageOverlayOutlet.alpha = 0.5
            cell?.imageOverlayOutlet.layer.cornerRadius = 30
        } else {
            
            self.friendIDs.removeValue(forKey: indexPath.row)
            cell?.imageOverlayOutlet.isHidden = true
        }
    }
    
}

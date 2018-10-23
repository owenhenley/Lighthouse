//
//  AddFriendsVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/22/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class AddFriendsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inviteFriendsTapped(_ sender: UIButton) {
        
        let message = "Hey! I got this new free app 'Lighthouse', lets hang out!"
        let appStoreLink = "AppStore link coming soon."
        
        let messageToShare = [message, appStoreLink]
        let shareAlert = UIActivityViewController(activityItems: messageToShare, applicationActivities: nil)
        
        shareAlert.popoverPresentationController?.sourceView = sender
        present(shareAlert, animated: true, completion: nil)
    }
}

extension AddFriendsVC: UITableViewDataSource, UITableViewDelegate {
    
    
    //MARK: UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendController.shared.pendingReuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "<#CellID#>", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}

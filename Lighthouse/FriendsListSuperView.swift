//
//  FriendsListContainerView.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 14/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit


protocol tableViewIndex: class {
    var tableViewIndex: Int {get set}
}

class FriendsListSuperView: UIViewController, UISearchBarDelegate{
    
    
    var pageViewController: FriendsListContainerVC?

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        searchBar.delegate = self
    }
    
    static weak var indexDelegate: tableViewIndex?
   
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        
        switch FriendsListSuperView.indexDelegate?.tableViewIndex {
        case 0:
            print("first index")
            FriendController.shared.searchFriends(text: searchText) { (success) in
                   }
        case 1:
            print("something")
        default:
            print("error")
        }
        
        
    }
    
    @IBAction func friendsTapped() {
        guard let friends = pageViewController?.friendsViewController else { return }
        // TODO: Get proper direction
        pageViewController?.setViewControllers([friends], direction: .forward, animated: true)
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        guard let add = pageViewController?.addViewController else {return}
        pageViewController?.setViewControllers([add], direction: .reverse, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainer" {
            pageViewController = segue.destination as? FriendsListContainerVC
        }
    }

}

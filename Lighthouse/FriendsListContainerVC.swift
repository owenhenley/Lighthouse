//
//  FriendsListVC.swift
//  Lighthouse
//
//  Created by Levi Linchenko on 12/10/2018.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit




class FriendsListContainerVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, tableViewIndex  {
    
    var tableViewIndex: Int = 0
    
    

    
    lazy var subViewControllers: [UIViewController] = {
        return [
           UIStoryboard(name: "FriendsList", bundle: nil).instantiateViewController(withIdentifier: "AddVC") as! AddTVC,
           UIStoryboard(name: "FriendsList", bundle: nil).instantiateViewController(withIdentifier: "FriendsVC") as! FriendsTVC,
           UIStoryboard(name: "FriendsList", bundle: nil).instantiateViewController(withIdentifier: "GroupVC") as! GroupTVC
        ]
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        FriendsListSuperView.indexDelegate = self
    }
    
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
  
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.index(of: viewController) ?? 0
        tableViewIndex = currentIndex
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.index(of: viewController) ?? 0
        tableViewIndex = currentIndex

        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex+1]
    }
    
}

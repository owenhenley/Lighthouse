//
//  OnboardingPVC.swift
//  Lighthouse
//
//  Created by Owen Henley on 10/25/18.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import UIKit

class OnboardingPVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
        // MARK: - Outlets
    
    
    
        // MARK: - Properties
    
    var pageControl = UIPageControl()
    // Set the pages to swipe through
    lazy var onboardingViewControllers: [UIViewController] = {
        return [
            self.newVC(viewController: "onboarding1"),
            self.newVC(viewController: "onboarding2"),
            self.newVC(viewController: "onboarding3"),
            self.newVC(viewController: "locationCheck")
        ]}()
    
    
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = onboardingViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

    }
    
    
    // Set what to swipe to before the current View
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = onboardingViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        return onboardingViewControllers[previousIndex]
    }
    
    
    // Set what to swipe to after the current VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = onboardingViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = onboardingViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else { return nil }
        
        guard orderedViewControllersCount > nextIndex else { return nil }
        
        
        return onboardingViewControllers[nextIndex]
    }
    
    
    // change the current page indicator dot
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = onboardingViewControllers.index(of: pageContentViewController)!
    }
    
    
    // Instantiate the View Controllers in Onboarding
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    //
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = onboardingViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.lightGray
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        //self.pageControl
        self.pageControl.currentPageIndicatorTintColor = UIColor.rustyOrange
        self.view.addSubview(pageControl)
    }
}

//
//  TabBarController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

//    var reachability = Reachability(hostName: "www.apple.com")
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
//        checkInternetFunction()
//        downloadData()
        
        let viewControllers: [UIViewController] =  [addStoreNavigationContorller(), setUpMapNavigationController(), userProfileNavigationController()]
        
        self.setViewControllers(viewControllers, animated: true)
        
        // Set up default page
        self.selectedViewController = viewControllers[1]
    }
    
//    func checkInternetFunction() -> Bool {
//
//        if reachability?.currentReachabilityStatus().rawValue == 0 {
//
//            print("no internet connected.")
//            return false
//        }else {
//
//            print("internet connected successfully.")
//            return true
//        }
//    }
    
//    func downloadData() {
//
//        if checkInternetFunction() == true {
//
//            print("internet connected successfully.")
//
//        }else {
//
//
//            let alert = UIAlertController(
//                title: "Oops!",
//                message: "No internet connected! Please try again.",
//                preferredStyle: .alert
//            )
//            alert.addAction(
//                UIAlertAction(
//                    title: "Ok",
//                    style: .cancel,
//                    handler: {(_ action: UIAlertAction) -> Void in
//
//                }))
//
//            self.present(alert, animated: true, completion: nil)
//
//        }
//    }

    func addStoreNavigationContorller() -> UINavigationController{
        
        let addStoreStoryBoard = UIStoryboard(name: "AddStoreStoryboard", bundle: nil)
        
        if let addStoreNavigationContorller = addStoreStoryBoard.instantiateViewController(withIdentifier: "AddStoreNavigation") as? AddStoreNavigationController {
            
            let addStoreTabBarItem = UITabBarItem(title: "Add", image: #imageLiteral(resourceName: "Add"), selectedImage: nil)
            
            addStoreNavigationContorller.tabBarItem = addStoreTabBarItem
            
            return addStoreNavigationContorller
        }
        
        return UINavigationController()
    }
    
    func setUpMapNavigationController() -> UINavigationController {
        
        let mapStoryBoard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        
        if let mapNavigationController =
            mapStoryBoard.instantiateViewController(withIdentifier: "MapNavigation") as? MapNavigationController {
            
            let mapTabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "Map"), selectedImage: nil)
            
            mapNavigationController.tabBarItem = mapTabBarItem
            
            return mapNavigationController
        }
        
        return UINavigationController()
    }
    
    func userProfileNavigationController() -> UINavigationController {
        
        let userProfileStoryBoard = UIStoryboard(name: "UserProfileStoryboard", bundle: nil)
        
        if let userProfileNavigationController = userProfileStoryBoard.instantiateViewController(withIdentifier: "UserProfileNavigation") as? UserProfileNavigationController {
            
            let userprofileTabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "UserProfile"), selectedImage: nil)
            
            userProfileNavigationController.tabBarItem = userprofileTabBarItem
            
            return userProfileNavigationController
        }
        
        return UINavigationController()
    }
}

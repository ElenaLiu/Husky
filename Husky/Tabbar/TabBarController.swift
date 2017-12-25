//
//  TabBarController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers: [UIViewController] =  [addStoreNavigationContorller(), setUpMapNavigationController(), userProfileNavigationController()]
    
        self.setViewControllers(viewControllers, animated: true)
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
    
    func addStoreNavigationContorller() -> UINavigationController{
        
        let addStoreStoryBoard = UIStoryboard(name: "AddStoreStoryboard", bundle: nil)
        
        if let addStoreNavigationContorller = addStoreStoryBoard.instantiateViewController(withIdentifier: "AddStoreNavigation") as? AddStoreNavigationController {
            let addStoreTabBarItem = UITabBarItem(title: "Add", image: #imageLiteral(resourceName: "Add"), selectedImage: nil)
            addStoreNavigationContorller.tabBarItem = addStoreTabBarItem
            
            return addStoreNavigationContorller
        }
        return UINavigationController()
    }
    
//    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
//        playBounceAnimation(icon)
//        textLabel.textColor = textSelectedColor
//    }
//
//    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
//        textLabel.textColor = defaultTextColor
//    }
//
//    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
//        textLabel.textColor = textSelectedColor
//    }
//
//    func playBounceAnimation(_ icon : UIImageView) {
//
//        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
//        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
//        bounceAnimation.duration = TimeInterval(duration)
//        bounceAnimation.calculationMode = kCAAnimationCubic
//
//        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
//    }
}

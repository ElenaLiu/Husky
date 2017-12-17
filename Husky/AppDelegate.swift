//
//  AppDelegate.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyC6K9j6suJcGaVnGjyCLdG3Ge59f0RDovM")
        GMSPlacesClient.provideAPIKey("AIzaSyC6K9j6suJcGaVnGjyCLdG3Ge59f0RDovM")
        
        logUser()  //寫完logout再➕回來
        return true
    }
    
    func logUser(){
        
        if Auth.auth().currentUser != nil {
            
            let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
            let tabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            self.window?.rootViewController = tabBar
        }
    }

}


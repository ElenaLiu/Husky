//
//  UserProfileViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/25.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfileViewController: UIViewController {
    
    let networkingService = NetworkingService()
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            
            let alert = UIAlertController(title: "標題", message: "確定要登出？", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
                
                self.networkingService.signOut()
                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login")
                
                self.present(vc, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScoreImage()

       
    }
    
    func setUpScoreImage() {
        
        self.userProfileImageView.layer.borderWidth = 1
        self.userProfileImageView.layer.masksToBounds = false
        self.userProfileImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        self.userProfileImageView.clipsToBounds = true
        
    }
}

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
import FirebaseStorage
import FirebaseDatabase
import Fusuma

class UserProfileViewController: UIViewController, FusumaDelegate {
    
    let networkingService = NetworkingService()
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        userProfileImageView.image = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    
    func fusumaCameraRollUnauthorized() {}
    
    
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
        
        if Auth.auth().currentUser == nil {
            let vc = UIStoryboard(
                name: "Login",
                bundle: nil
                ).instantiateViewController(withIdentifier: "Login")
            
            self.present(vc, animated: true, completion: nil)
        }else {
            
            
            let uid = Auth.auth().currentUser?.uid
            networkingService.databaseRef.child("Users").child(uid!).observe(.value, with: { (snapshot) in
                DispatchQueue.main.async {
                    if let snapshotValue = snapshot.value,
                        let snapshotValueDics = snapshotValue as? [String: Any] {
                        for snapshotValueDic in snapshotValueDics {
                            if let valueDic = snapshotValueDic.value as? [String: Any],
                                let uidValue = valueDic["uid"] as? String,
                                let nameValue = valueDic["username"] as? String,
                                let emailValue = valueDic["email"] as? String,
                                let photoUrlValue = valueDic["photoUrl"] as? String {
                                    print("343443\(valueDic)")
                            }
                        }
                    }
                }

            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func checkIfUserIsLoggedIn() {
        
    }
    
    func setUpScoreImage() {
        
        self.userProfileImageView.layer.borderWidth = 1
        self.userProfileImageView.layer.masksToBounds = false
        self.userProfileImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        self.userProfileImageView.clipsToBounds = true
        
    }
}

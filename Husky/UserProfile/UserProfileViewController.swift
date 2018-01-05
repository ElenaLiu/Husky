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
import SDWebImage
import SCLAlertView

class UserProfileViewController: UIViewController, FusumaDelegate {
    
    let networkingService = NetworkingService()
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        userProfileImageView.image = image
        userProfileImageView.contentMode = .scaleAspectFill
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    
    func fusumaCameraRollUnauthorized() {}
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            
            let alert = UIAlertController(title: "", message: "確定要登出？", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
                
                self.networkingService.signOut()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        setUpsaveProfileInfoTapped()
        
        fetchUserProfile()
   
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow),
                                       name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //tap anywhere to hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(dismissKeyboard)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUserProfileImage()

    }
    
    // Remove observer
    deinit {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        
    }
    
    func setUpsaveProfileInfoTapped() {
  
        let saveProfileInfoTapped = UIButton(type: .system)
        saveProfileInfoTapped.setImage(#imageLiteral(resourceName: "Save").withRenderingMode(.alwaysOriginal), for: .normal)
        saveProfileInfoTapped.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveProfileInfoTapped)
        saveProfileInfoTapped.addTarget(self, action: #selector(saveProfileInfoAction), for: .touchUpInside)
        
        }
    
    @objc func saveProfileInfoAction() {
        
        if let user = Auth.auth().currentUser {
            
            let alert = UIAlertController(title: "", message: "更新個人資料？", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
                
                let imageData = UIImageJPEGRepresentation(self.userProfileImageView.image!, 0.8)
                self.networkingService.setUserInfo(user: user, username: self.nameTextField.text!, password: "", data: imageData)
                
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func fetchUserProfile(){
        
        if let user = Auth.auth().currentUser {
            
            self.nameTextField.text = user.displayName
            self.emailTextField.text = user.email
            
            self.userProfileImageView.sd_setImage(with: user.photoURL, completed: nil)
            
        } else {
            let vc = UIStoryboard(
                name: "Login",
                bundle: nil
                ).instantiateViewController(withIdentifier: "Login")
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func setUpNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setUpUserProfileImage() {

        self.userProfileImageView.layer.borderWidth = 0
        self.userProfileImageView.layer.masksToBounds = false
        self.userProfileImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.size.height / 2.0
        print("223\(userProfileImageView.bounds)")
        self.userProfileImageView.clipsToBounds = true
    }
    
    // Handling keyboard
    @objc func keyboardWillShow(notification: Notification)
    {
        
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardCGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: keyboardCGRect.height,
                                         right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollRectToVisible(keyboardCGRect, animated: true)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func dismissKeyboard() {
        
        nameTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
}

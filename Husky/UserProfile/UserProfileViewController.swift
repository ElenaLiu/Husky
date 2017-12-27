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
    
    @IBAction func saveProfileInfo(_ sender: Any) {

        if let user = Auth.auth().currentUser {
            let imageData = UIImageJPEGRepresentation(userProfileImageView.image!, 0.8)
            networkingService.setUserInfo(user: user, username: nameTextField.text!, password: "", data: imageData)
        }
    }
    
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
        
        setUpNavigationBar()
   
            
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
    
    // Remove observer
    deinit {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        
    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let image = #imageLiteral(resourceName: "Save")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageView)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView  
    }
    
    func setUpScoreImage() {
        
        self.userProfileImageView.layer.borderWidth = 0
        self.userProfileImageView.layer.masksToBounds = false
        self.userProfileImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width/2.0
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

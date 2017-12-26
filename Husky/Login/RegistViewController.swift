//
//  RegistViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/15.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SCLAlertView
import Fusuma


class RegistViewController: UIViewController, FusumaDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var registNameTextField: UITextField!
    @IBOutlet weak var registEmailTextField: UITextField!
    @IBOutlet weak var registPasswordTextField: UITextField!
    
    
    @IBAction func backToLoginIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var registImageView: UIImageView!
    
    var networkingService = NetworkingService()
    
    
    @IBOutlet weak var signUpTapped: UIButton!
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let data = UIImageJPEGRepresentation(self.registImageView.image!, 0.8)
        
        //SCLAlertView().showNotice("Hi~", subTitle: "喝杯珍奶吧～")
   
        
        networkingService.signUp(email: registEmailTextField.text!,
                                 username: registNameTextField.text!,
                                 password: registPasswordTextField.text!,
                                 data: data!)

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpregistImage()
        setUpRegistTapped()
        
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
    
    func setUpregistImage() {
        
        self.registImageView.layer.borderWidth = 1
        self.registImageView.layer.masksToBounds = false
        self.registImageView.layer.borderColor = UIColor.black.cgColor
        self.registImageView.layer.cornerRadius = registImageView.frame.height/2
        self.registImageView.clipsToBounds = true
    }
    
    func setUpRegistTapped() {
        
        self.signUpTapped.layer.cornerRadius = 5
    }
    

    @IBAction func chooseUserImage(_ sender: Any) {
        
        //init Fusuma
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        registImageView.image = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    
    func fusumaCameraRollUnauthorized() {}
    
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
        
        registNameTextField.resignFirstResponder()
        registEmailTextField.resignFirstResponder()
        registPasswordTextField.resignFirstResponder()

    }
}



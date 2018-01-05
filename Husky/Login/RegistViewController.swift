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
import SkyFloatingLabelTextField

class RegistViewController: UIViewController, FusumaDelegate {
    
        var networkingService = NetworkingService()

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var registNameTextField: UITextField!
    
    @IBOutlet weak var registEmailTextField: UITextField!
    
    @IBOutlet weak var registPasswordTextField: UITextField!
    
    @IBOutlet weak var registImageView: UIImageView!
    
    @IBOutlet weak var signUpTapped: UIButton!
    
    @IBAction func backToLoginIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        startLoading(status: "Loading")
        
        let data = UIImageJPEGRepresentation(self.registImageView.image!, 0.8)
        
        //SCLAlertView().showNotice("Hi~", subTitle: "喝杯珍奶吧～")
   
        networkingService.signUp(email: registEmailTextField.text!,
                                 username: registNameTextField.text!,
                                 password: registPasswordTextField.text!,
                                 data: data!)
        
        //Tapped button and dismiss keyboard
        view.endEditing(true)
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkingService.delegate = self
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpregistImage()
    }
    
    // MARK: Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Class function
    func setUpregistImage() {
        
        self.registImageView.layer.borderWidth = 1
        self.registImageView.layer.masksToBounds = false
        self.registImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.registImageView.layer.cornerRadius = registImageView.frame.height/2.0
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
    
    //MARK: FusumaDelegate function
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        registImageView.image = image
        registImageView.contentMode = .scaleAspectFill
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    
    func fusumaCameraRollUnauthorized() {}
    
    //MARK: Handling keyboard
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

extension RegistViewController: NetworkingServiceDelegate {
    
    func didFail(with error: Error) {
        
        endLoading()
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UITextFieldDelegate function
//extension RegistViewController: UITextFieldDelegate  {
//
//    func textFieldErrorHandle() {
//
//
//        registEmailTextField.delegate = self
//        registPasswordTextField.delegate = self
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField === registEmailTextField {
//            if let text = textField.text {
//                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
//                    if(text.count < 3 || !text.contains("@")) {
//                        floatingLabelTextField.errorMessage = "Invalid email"
//                    }
//                    else {
//                        // The error message will only disappear when we reset it to nil or empty string
//                        floatingLabelTextField.errorMessage = ""
//                    }
//                }
//            }
//        }else if textField === registPasswordTextField {
//            if let text = textField.text {
//                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
//                    if(text.count < 7 ) {
//                        floatingLabelTextField.errorMessage = "Invalid password"
//                    }
//                    else {
//                        // The error message will only disappear when we reset it to nil or empty string
//                        floatingLabelTextField.errorMessage = ""
//                    }
//                }
//            }
//
//        }
//        return true
//    }
//}


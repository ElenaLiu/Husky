//
//  LoginViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginEmailAddressTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    let networkingService = NetworkingService()

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
        
        
        let alertController = UIAlertController(title: "忘記密碼?",
                                                message: "Enter your E-mail", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler:
            
            {(_ textField: UITextField) -> Void in
            
            textField.placeholder = "Your E-mail"
            
        })
        
        let confirmAction = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler:
            {(_ action: UIAlertAction) -> Void in
            
            guard let email = alertController.textFields?.first?.text else { return }
            
            self.networkingService.resetPassword(email: email)
            
        })
        
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var loginTapped: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        
        networkingService.signIn(email: loginEmailAddressTextField.text!,
                                 password: loginPasswordTextField.text!)
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            appdelegate.logUser()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoginTapped()
        
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
    
    // Handling keyboard
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardCGRect =
            (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: keyboardCGRect.height,
                                         right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollRectToVisible(keyboardCGRect,
                                       animated: true)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
        
    }
    
    @objc func dismissKeyboard() {
        
        loginEmailAddressTextField.resignFirstResponder()
        loginPasswordTextField.resignFirstResponder()
        
    }
    
    func setUpLoginTapped() {
        
        self.loginTapped.layer.cornerRadius = 5
    }
    
}

extension LoginViewController {
    func setUpErrorTextFieldHandeler() {
        
        loginEmailAddressTextField.delegate = self
        loginEmailAddressTextField.tag = 1
        
        loginPasswordTextField.delegate = self
        loginPasswordTextField.tag = 2
        
    }
    
    // Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    
//    func textField(
//        textField: UITextField,
//        shouldChangeCharactersInRange range: NSRange,
//        replacementString string: String
//        ) -> Bool {
//
//        if let text = textField.text {
//            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
//                if(text.characters.count < 3 || !text.containsString("@")) {
//                    text.errorMessage = "Invalid email"
//                }
//                else {
//                    // The error message will only disappear when we reset it to nil or empty string
//                    floatingLabelTextField.errorMessage = ""
//                }
//            }
//        }
//        return true
//    }

    

}


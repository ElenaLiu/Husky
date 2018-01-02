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
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginEmailAddressTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    let networkingService = NetworkingService()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoginTapped()
        
        textFieldErrorHandle()
        
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // Handling keyboard
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardCGRect =
            (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: keyboardCGRect.height - 200,
                                         right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollRectToVisible(
            keyboardCGRect,
            animated: true
        )
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

extension LoginViewController: UITextFieldDelegate  {
    
    func textFieldErrorHandle() {
        
        loginEmailAddressTextField.delegate = self
        loginPasswordTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField === loginEmailAddressTextField {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = "Invalid email"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
            
        }else if textField === loginPasswordTextField {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.count < 7 ) {
                        floatingLabelTextField.errorMessage = "Invalid password"
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        return true
    }
}



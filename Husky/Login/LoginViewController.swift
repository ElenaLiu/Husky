//
//  LoginViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
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
    
    
    @IBAction func loginInTapped(_ sender: Any) {
        
        networkingService.signIn(email: loginEmailAddressTextField.text!,
                                 password: loginPasswordTextField.text!)
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}














 /*       //sign in existing users
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                let alertController = UIAlertController(title: "Alert",
                                                        message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(
                    UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: nil)
                )
                self.present(alertController, animated: true, completion: nil)
                return
            }
            print("logged in")
            
            let sb = UIStoryboard(name: "StoreDetailStoryboard", bundle: nil)
            let vc = sb.instantiateViewController(witchIdentifier: "StoreDetailViewController")
            self.present(vc, animated: true, completion: nil)
            return
        }
    }
}
*/

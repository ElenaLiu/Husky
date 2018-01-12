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
    
    var networkingService = NetworkingService()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginEmailAddressTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var loginTapped: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        
        startLoading(status: "Loading")
        
        networkingService.signIn(email: loginEmailAddressTextField.text!,
                                 password: loginPasswordTextField.text!)
        //Tapped button and dismiss keyboard
        view.endEditing(true)
    }

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Forgot password?", comment: ""),
                                                message: NSLocalizedString("Enter your E-mail", comment: ""), preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler:
            
            {(_ textField: UITextField) -> Void in
                
                textField.placeholder = NSLocalizedString("Your E-mail", comment: "")
                
        })
        
        let confirmAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                          style: .default,
                                          handler:
            {(_ action: UIAlertAction) -> Void in
                
                guard let email = alertController.textFields?.first?.text else { return }
                
                self.networkingService.resetPassword(email: email)
                
        })
        
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC init")
        networkingService.delegate = self
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
        print("loginVC deinit")
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
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
        loginTapped.resignFirstResponder()
        
    }
    
    func setUpLoginTapped() {
        self.loginTapped.layer.cornerRadius = 5
    }
}

extension LoginViewController: NetworkingServiceDelegate {
    func didFail(with error: Error) {
        
        endLoading()
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
        
    }
}


//extension LoginViewController: UITextFieldDelegate  {
//
//    func textFieldErrorHandle() {
//
//        loginEmailAddressTextField.delegate = self
//        loginPasswordTextField.delegate = self
//    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField === loginEmailAddressTextField {
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
//
//        }else if textField === loginPasswordTextField {
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
//        }
//        return true
//    }
//}




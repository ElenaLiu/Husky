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
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Fonts.SentyWen16,
            kTextFont: Fonts.SentyWen16,
            kButtonFont: Fonts.SentyWen16,
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        let emailTextField = alertView.addTextField(NSLocalizedString("Your E-mail", comment: ""))
        
        alertView.addButton(
            NSLocalizedString("Ok", comment: ""),
            action: {
                
                self.networkingService.resetPassword(email: emailTextField.text!)
        })
        
        
        alertView.addButton(NSLocalizedString("Cancel", comment: "")) {
        }
        
        alertView.showWarning(
            NSLocalizedString("Forgot password?", comment: ""),
            subTitle: NSLocalizedString("Enter your E-mail", comment: "")
        )
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Fonts.SentyWen16,
            kTextFont: Fonts.SentyWen16,
            kButtonFont: Fonts.SentyWen16,
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton(
            NSLocalizedString("Ok ", comment: ""),
            action: {
        })
        
        alertView.showError(
            "Error!",
            subTitle: error.localizedDescription
        )
    }
}

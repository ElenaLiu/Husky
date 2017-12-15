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

    @IBOutlet weak var loginEmailAddressTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    let networkingService = NetworkingService()

    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
    
    
    @IBAction func loginInTapped(_ sender: Any) {
        
        networkingService.signIn(email: loginEmailAddressTextField.text!, password: loginPasswordTextField.text!)
        
//        guard
//            let email = loginEmailAddressTextField.text,
//            let password = loginPasswordTextField.text
//            else {
//                print("Form is not valid")
//                return
        
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

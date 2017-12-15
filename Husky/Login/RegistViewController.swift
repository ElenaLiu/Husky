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

class RegistViewController: UIViewController {
    @IBAction func backToLoginIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var registEmailAdressField: UITextField!
    @IBOutlet weak var registNameField: UITextField!
    @IBOutlet weak var registPasswordField: UITextField!
    @IBOutlet weak var registImageView: UIImageView!
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        guard
            let email = registEmailAdressField.text,
            let password = registPasswordField.text,
            let name = registNameField.text
            else {
                print("Form is not valid")
                return
                
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                let alertController = UIAlertController(title: "Alert",
                                                        message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok",
                                                        style: .default,
                                                        handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            let ref = Database.database().reference()
            
            let values = ["Email": email, "Name": name]
            let userReference = ref.child("Users").child(uid)
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                print("Saved user successfully into Firebase db.")
            })
            let alertController = UIAlertController(title: "Congratulation!",
                                                    message: "Seccessfully Sign Up", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(
                UIAlertAction(title: "OK",
                              style: .default,
                              handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                })
            )
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

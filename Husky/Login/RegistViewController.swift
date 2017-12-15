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

class RegistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func backToLoginIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var registEmailAdressField: UITextField!
    @IBOutlet weak var registNameField: UITextField!
    @IBOutlet weak var registPasswordField: UITextField!
    @IBOutlet weak var registImageView: UIImageView!
    
    var networkingService = NetworkingService()
    
    @IBAction func signUpButton(_ sender: Any) {
        
//        guard let selectedImage = registImageView.image else { return }
        
        let data = UIImageJPEGRepresentation(self.registImageView.image!, 0.8)
        
        networkingService.signUp(email: registEmailAdressField.text!, username: registNameField.text!, password: registPasswordField.text!, data: data! as NSData)
        
        
//        guard
//            let email = registEmailAdressField.text,
//            let password = registPasswordField.text,
//            let name = registNameField.text
//            else {
//                print("Form is not valid")
//                return
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpregistImage()

    }
    

    
    func setUpregistImage() {
        self.registImageView.layer.borderWidth = 1
        self.registImageView.layer.masksToBounds = false
        self.registImageView.layer.borderColor = UIColor.black.cgColor
        self.registImageView.layer.cornerRadius = registImageView.frame.height/2
        self.registImageView.clipsToBounds = true
    }

    @IBAction func chooseUserImage(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismiss(animated: true, completion: nil)
        self.registImageView.image = image
    }
}











//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                print(error?.localizedDescription)
//                let alertController = UIAlertController(title: "Alert",
//                                                        message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
//                alertController.addAction(UIAlertAction(title: "Ok",
//                                                        style: .default,
//                                                        handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//                return
//            }
//            guard let uid = user?.uid else {
//                return
//            }
//            let ref = Database.database().reference()
//
//            let values = ["Email": email, "Name": name]
//            let userReference = ref.child("Users").child(uid)
//            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//                if err != nil {
//                    print(err)
//                    return
//                }
//                print("Saved user successfully into Firebase db.")
//            })
//            let alertController = UIAlertController(title: "Congratulation!",
//                                                    message: "Seccessfully Sign Up", preferredStyle: UIAlertControllerStyle.alert)
//
//            alertController.addAction(
//                UIAlertAction(title: "OK",
//                              style: .default,
//                              handler: { (action) in
//                                self.navigationController?.popViewController(animated: true)
//                })
//            )
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//}


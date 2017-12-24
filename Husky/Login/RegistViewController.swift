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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var registNameTextField: UITextField!
    @IBOutlet weak var registEmailTextField: UITextField!
    @IBOutlet weak var registPasswordTextField: UITextField!
    
    
    
    @IBAction func backToLoginIn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var registImageView: UIImageView!
    
    var networkingService = NetworkingService()
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let data = UIImageJPEGRepresentation(self.registImageView.image!, 0.8)
        
        networkingService.signUp(email: registEmailTextField.text!,
                                 username: registNameTextField.text!,
                                 password: registPasswordTextField.text!,
                                 data: data!)

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpregistImage()
        
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

    @IBAction func chooseUserImage(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Picture",
                                                message: "Choose From", preferredStyle: .actionSheet)
       
        let photosLibraryAction = UIAlertAction(title: "Photos Library",
                                                style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
                                                    
            self.present(pickerController,
                         animated: true,
                         completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            
            self.present(pickerController,
                         animated: true,
                         completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive,
                                         handler: nil)
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            let cameraAction = UIAlertAction(
                title: "Camera",
                style: .default
            ) {(action) in
                pickerController.sourceType = .camera
                                                
//                //Creat camera overlay
//                let pickerFrame = CGRect(
//                    x: 0,
//                    y: UIApplication.shared.statusBarFrame.size.height,
//                    width: pickerController.view.bounds.width,
//                    height: pickerController.view.bounds.height - pickerController.navigationBar.bounds.size.height - pickerController.toolbar.bounds.size.height
//                )
//
//                let squareFrame = CGRect(
//                    x: pickerFrame.width/2 - 200/2,
//                    y: pickerFrame.height/2 - 200/2,
//                    width: 200,
//                    height: 200
//                )
//                UIGraphicsBeginImageContext(pickerFrame.size)
                
//                let context = UIGraphicsGetCurrentContext()
//                CGContext.saveGState(context!)
//                CGContext.move(context, squareFrame.origin.x, squareFrame.origin.y)
//                CGContext.addLine(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y)
                
                self.present(
                    pickerController,
                    animated: true,
                    completion: nil
                )
            }
            
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            registImageView.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
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



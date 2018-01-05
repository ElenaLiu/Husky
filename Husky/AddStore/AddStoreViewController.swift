//
//  AddStoreViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/22.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import Firebase
import SkyFloatingLabelTextField

class AddStoreViewController: UIViewController {
    
    var placeInfo: GMSPlace?
    
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var storePhoneNumberTextField: UITextField!
    
    @IBOutlet weak var storeAddressTextField: UITextField!

    @IBOutlet weak var addStoreButton: UIButton!
    
    @IBAction func addStoreTapped(_ sender: Any) {
        
        storeNameTextField.text = ""
        storePhoneNumberTextField.text = ""
        storeAddressTextField.text = ""
        
        let config = GMSPlacePickerConfig(viewport: nil)
        
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            self.placeInfo = place
            
            self.storeNameTextField.text = place.name
            self.storeNameTextField.isEnabled = false
            
            if let phoneNumber = place.phoneNumber {
                self.storePhoneNumberTextField.isEnabled = false
                self.storePhoneNumberTextField.text = place.phoneNumber
            }else {
                self.storePhoneNumberTextField.isEnabled = true
            }
            
            if let address = place.formattedAddress {
                self.storeAddressTextField.isEnabled = false
                self.storeAddressTextField.text = place.formattedAddress
            }else {
                self.storeAddressTextField.isEnabled = true
            }
        })
    }
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        setUpSaveStoreTapped()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //tap anywhere to hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    deinit {
        
    let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpTextField()
        storeAddressTextField.setGradient(colorOne: Colors.pinkyred, colorTwo: Colors.lightpinkyred)
        
        storePhoneNumberTextField.setGradient(colorOne: Colors.seaGreen, colorTwo: Colors.lightSeaGreen)
        
        storeNameTextField.setGradient(colorOne: Colors.purple, colorTwo: Colors.lightPurple)
    }
    //MARK: Navigation Bar
    func setUpNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

    }
    //MARK: SaveStoreTapped
    func setUpSaveStoreTapped() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "送出", style: .plain, target: self, action: #selector(saveStoreAction))
    }

    @objc func saveStoreAction() {
        
        let alert = UIAlertController(title: "", message: "我發自內心覺得這家好喝！！", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
            StoreProvider.shared.saveStore(place: self.placeInfo!)
        }))
        alert.addAction(UIAlertAction(title: "我再想一下", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpTextField() {
        
        self.storeNameTextField.layer.borderWidth = 0
        self.storeNameTextField.layer.masksToBounds = false
        self.storeNameTextField.layer.borderColor = UIColor.gray.cgColor
        self.storeNameTextField.layer.cornerRadius = 20
        self.storeNameTextField.clipsToBounds = true
        
        self.storeAddressTextField.layer.borderWidth = 0
        self.storeAddressTextField.layer.masksToBounds = false
        self.storeAddressTextField.layer.borderColor = UIColor.gray.cgColor
        self.storeAddressTextField.layer.cornerRadius = 20
        self.storeAddressTextField.clipsToBounds = true
        
        self.storePhoneNumberTextField.layer.borderWidth = 0
        self.storePhoneNumberTextField.layer.masksToBounds = false
        self.storePhoneNumberTextField.layer.borderColor = UIColor.gray.cgColor
        self.storePhoneNumberTextField.layer.cornerRadius = 20
        self.storePhoneNumberTextField.clipsToBounds = true
    }
    //MARK: Handling keyboard
    @objc func keyboardWillShow(notification: Notification) {
        
        let userInfo = (notification as Notification).userInfo
        let keyboardCGRact = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardCGRact.height - 200, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollRectToVisible(keyboardCGRact, animated: true)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func dismissKeyboard() {
        
        storePhoneNumberTextField.resignFirstResponder()
        storeAddressTextField.resignFirstResponder()
        storeNameTextField.resignFirstResponder()
    }
}



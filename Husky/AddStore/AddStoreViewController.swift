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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        setUpSaveStoreTapped()
        
        //tap anywhere to hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpTextField()
        storeAddressTextField.setGradient(colorOne: Colors.pinkyred, colorTwo: Colors.lightpinkyred)
        
        storePhoneNumberTextField.setGradient(colorOne: Colors.seaGreen, colorTwo: Colors.lightSeaGreen)
        
        storeNameTextField.setGradient(colorOne: Colors.purple, colorTwo: Colors.lightPurple)
    }

    func setUpNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
//        navigationController?.navigationBar.titleTextAttributes =
//        let textView = UITextView()
//        textView.text = "i Bubble"
//        textView.isEditable = false
//        textView.isSelectable = false
//        textView.font = UIFont(name: "Chalkduster", size: 25)
//        textView.textAlignment = .center
//        textView.showsHorizontalScrollIndicator = false
//        textView.showsVerticalScrollIndicator = false
//        textView.sizeToFit()
//        navigationItem.titleView = textView
    }
    
    func setUpSaveStoreTapped() {
        
        let saveStoreTapped = UIButton(type: .custom)
        saveStoreTapped.setImage(#imageLiteral(resourceName: "AddStore").withRenderingMode(.alwaysTemplate), for: .normal)
        saveStoreTapped.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveStoreTapped)
        saveStoreTapped.addTarget(self, action: #selector(saveStoreAction), for: .touchUpInside)
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
    
    @objc func dismissKeyboard() {
        
        storePhoneNumberTextField.resignFirstResponder()
        storeAddressTextField.resignFirstResponder()
        storeNameTextField.resignFirstResponder()
    }
}



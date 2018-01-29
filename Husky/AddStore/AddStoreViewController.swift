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
import SCLAlertView
import CoreLocation

class AddStoreViewController: UIViewController {
    
    //MARK: Properties
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
                self.storePhoneNumberTextField.text = phoneNumber
            }else {
                
                self.storePhoneNumberTextField.isEnabled = true
            }
            
            if let address = place.formattedAddress {
                
                self.storeAddressTextField.isEnabled = false
                self.storeAddressTextField.text = address
            }else {
                
                self.storeAddressTextField.isEnabled = true
            }
        })
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setUpNavigationBar()
        
        setUpSaveStoreTapped()
        
        storeAddressTextField.setGradient(colorOne: Colors.pinkyred, colorTwo: Colors.lightpinkyred)
        
        storePhoneNumberTextField.setGradient(colorOne: Colors.seaGreen, colorTwo: Colors.lightSeaGreen)
        
        storeNameTextField.setGradient(colorOne: Colors.blue, colorTwo: Colors.lightblue)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self, selector: #selector(keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        //tap anywhere to hide keyboard
        self.view.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(dismissKeyboard)
        ))
    }
    
    deinit {
        
    let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        storeNameTextField.text = ""
        storePhoneNumberTextField.text = ""
        storeAddressTextField.text = ""
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpTextField()
    }
    
    //MARK: Navigation Bar
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    //MARK: SaveStoreTapped
    func setUpSaveStoreTapped() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Send", comment: ""),
            style: .plain,
            target: self,
            action: #selector(saveStoreAction))
    }

    @objc func saveStoreAction() {
        
        dismissKeyboard()
        if storeNameTextField.text == "" ||
            storeAddressTextField.text == "" ||
            storePhoneNumberTextField.text == "" {
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: Fonts.SentyWen16,
                kTextFont: Fonts.SentyWen16,
                kButtonFont: Fonts.SentyWen16
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showWarning("", subTitle: NSLocalizedString("Fields that are required.", comment: ""))
            
        }else {
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: Fonts.SentyWen16,
                kTextFont: Fonts.SentyWen16,
                kButtonFont: Fonts.SentyWen16,
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton(
                NSLocalizedString(" Yes ", comment: ""),
                action: {
                    if self.placeInfo == nil {
                        guard let name = self.storeNameTextField.text,
                        let address = self.storeAddressTextField.text,
                        let phone = self.storePhoneNumberTextField.text else { return }
                      
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                            guard let placemarks = placemarks,
                                let location = placemarks.first?.location else {
                                    
                                    let appearance = SCLAlertView.SCLAppearance(
                                        kTitleFont: Fonts.SentyWen16,
                                        kTextFont: Fonts.SentyWen16,
                                        kButtonFont: Fonts.SentyWen16,
                                        showCloseButton: false
                                    )
                                    
                                    let alertView = SCLAlertView(appearance: appearance)
                                    
                                    alertView.addButton(
                                        NSLocalizedString("Ok", comment: ""),
                                        action: {
                                            self.storeNameTextField.text = ""
                                            self.storeAddressTextField.text = ""
                                            self.storePhoneNumberTextField.text = ""
                                    })
                                    
                                    alertView.showError("", subTitle: NSLocalizedString("Wrong address format, plase try again.", comment: ""))
                                    return
                            }
                            StoreProvider.shared.saveStoreWithoutGMSPlace(name: name, address: address, phone: phone, location: location)
                            self.storeNameTextField.text = ""
                            self.storeAddressTextField.text = ""
                            self.storePhoneNumberTextField.text = ""
                        })
                    }else {
                        
                        StoreProvider.shared.saveStore(place: self.placeInfo!)
                        self.storeNameTextField.text = ""
                        self.storeAddressTextField.text = ""
                        self.storePhoneNumberTextField.text = ""
                    }
            })
            
            alertView.addButton(
                NSLocalizedString("No ", comment: ""),
                action: {}
            )
            
            alertView.showSuccess("", subTitle: NSLocalizedString("Send?", comment: ""))
        }
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
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardCGRact.height - 200,
            right: 0
        )
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



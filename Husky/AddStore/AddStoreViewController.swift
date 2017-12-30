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
    
    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var storePhoneNumberTextField: UITextField!
    
    @IBOutlet weak var storeAddressTextField: UITextField!
    
    @IBAction func saveStoreTapped(_ sender: Any) {
        
        StoreProvider.shared.saveStore(place: self.placeInfo!)
    }

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
    }
    
    
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 28)!]
        navigationItem.title = "i Bubble"
        
//        let image = #imageLiteral(resourceName: "AddStore")
//        let imageView = UIImageView(image: image)
//        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageView)
//        imageView.contentMode = .scaleAspectFit
//        navigationItem.rightBarButtonItem?.customView = imageView
    }
}




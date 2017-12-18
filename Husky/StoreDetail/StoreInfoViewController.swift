//
//  StoreInfoViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class StoreInfoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMapView: UIView!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }

}

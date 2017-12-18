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
import Alamofire
import SwiftyJSON


class StoreInfoViewController: UIViewController {
    
    
    var selectedMarkerId: Store?
    
    var addressValue: String!
    var phoneValue: String!
    var scorePeopleValue: Double!
    
    @IBOutlet weak var myMapView: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var scorePeopleLabel: UILabel!
    
    @IBAction func phoneCallTapped(_ sender: Any) {
        
        guard let phoneValue = phoneValue else { return }
        if let phoneCallURL = URL(string: "tel://\(phoneValue)") {
            let application = UIApplication.shared
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    

    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var endPosition: CLLocation?
    


    override func viewDidLoad() {
        super.viewDidLoad()
       setUpStoreInfoWith()
        
    }
    
    //address: String, phone: String, scorePeople: Double
    private func setUpStoreInfoWith() {
        if let addressValue = addressValue, let phoneValue = phoneValue, let scorePeopleValue = scorePeopleValue {
            addressLabel.text = "地址：\(addressValue)"
            phoneLabel.text = "電話：\(phoneValue)"
            scorePeopleLabel.text = "\(scorePeopleValue)則評論"
        }
    }
    
    //Initialize the location manager and GMSPlacesClient
    private func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        
        self.placesClient = GMSPlacesClient.shared()
    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    private func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        print("我是 \(url)")
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            if routes == [] {
                let alert = UIAlertController(title: "Oops!", message: "Distance is too far, can't show the path.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }else {
                
            }
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 3
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
        }
    }
}

extension StoreInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.map = mapView
        marker.icon = UIImage(named: "Bubble")
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        if let end = endPosition {
            drawPath(startLocation: location, endLocation: end)
        }
    }
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


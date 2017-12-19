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
import Cosmos
import Firebase


class StoreInfoViewController: UIViewController {
    
    
    var selectedMarkerId: Store?
    
    //var ref = DatabaseReference!()
    
    var addressValue: String!
    var phoneValue: String!
    var scorePeopleValue: Int!
    var longitudeValue: CLLocationDegrees!
    var latitudeValue: CLLocationDegrees!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var endPosition: CLLocation?
    
    
    @IBOutlet weak var myMapView: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var scorePeopleLabel: UILabel!
    
    @IBOutlet weak var scoreAverageView: CosmosView!
    
    // Make phone call
    @IBAction func phoneCallTapped(_ sender: Any) {
        
        guard let phoneValue = phoneValue else { return }
        if let phoneCallURL = URL(string: "tel://\(phoneValue)") {
            let application = UIApplication.shared
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBOutlet weak var addressGuideTapped: UIButton!
    // Make google guide
    @IBAction func addressGuideTapped(_ sender: Any) {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(addressValue)&daddr=John+F.+Kennedy+International+Airport,+Van+Wyck+Expressway,+Jamaica,+New+York&directionsmode=transit")!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    override func loadView() {
        super.loadView()
    
    if let selectedMarkerId = self.selectedMarkerId {
        setUpMapView(latitude: selectedMarkerId.latitude, longitude: selectedMarkerId.longitude)
    }
//
//        let camera = GMSCameraPosition.camera(withLatitude: latitudeValue, longitude: longitudeValue, zoom: zoomLevel)
//        self.mapView = GMSMapView.map(withFrame: myMapView.bounds, camera: camera)
//        mapView.isMyLocationEnabled = true
//        myMapView.addSubview(mapView)
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: longitudeValue, longitude: longitudeValue)
//        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
//        marker.map = mapView
//        marker.icon = UIImage(named: "BubbleTea(brown)")
//
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpStoreInfoWith()
        initLocationManager()

        
    }
    

    private func setUpStoreInfoWith() {
        if let addressValue = addressValue, let phoneValue = phoneValue, let scorePeopleValue = scorePeopleValue {
            addressLabel.text = "地址：\(addressValue)"
            phoneLabel.text = "電話：\(phoneValue)"
            scorePeopleLabel.text = "\(scorePeopleValue)則評論"
        }
    }
    
    private func setUpScoreAverage() {
        
        //ref = Database.database().reference()
        
        //scoreAverageView.rating =
        
    }
    
    //Initialize the location manager and GMSPlacesClient
    private func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self as? CLLocationManagerDelegate
        
        self.placesClient = GMSPlacesClient.shared()
    }
    
    private func setUpMapView(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: myMapView.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        myMapView.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: longitudeValue, longitude: longitudeValue)
        marker.map = mapView
        marker.icon = UIImage(named: "BubbleTea(brown)")


    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    
//    private func drawPath(startLocation: CLLocation, endLocation: CLLocation)
//    {
//        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
//        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
//
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
//        print("我是 \(url)")
//
//        Alamofire.request(url).responseJSON { response in
//
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // HTTP URL response
//            print(response.data as Any)     // server data
//            print(response.result as Any)   // result of response serialization
//
//            let json = try! JSON(data: response.data!)
//            let routes = json["routes"].arrayValue
//            if routes == [] {
//                let alert = UIAlertController(title: "Oops!", message: "Distance is too far, can't show the path.", preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//
//                }))
//
//                self.present(alert, animated: true, completion: nil)
//            }else {
//
//            }
//
//            // print route using Polyline
//            for route in routes
//            {
//                let routeOverviewPolyline = route["overview_polyline"].dictionary
//                let points = routeOverviewPolyline?["points"]?.stringValue
//                let path = GMSPath.init(fromEncodedPath: points!)
//                let polyline = GMSPolyline.init(path: path)
//                polyline.strokeWidth = 3
//                polyline.strokeColor = UIColor.red
//                polyline.map = self.mapView
//            }
//        }
//    }
}

//extension StoreInfoViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location: CLLocation = locations.last!
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        marker.map = mapView
//        marker.icon = UIImage(named: "Bubble")
//
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
//
//        if let end = endPosition {
//            drawPath(startLocation: location, endLocation: end)
//        }
//    }
//    // Handle location manager errors.
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        print("Error: \(error)")
//    }
//}


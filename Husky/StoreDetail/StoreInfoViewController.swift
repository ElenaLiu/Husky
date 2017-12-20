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
import SDWebImage


class StoreInfoViewController: UIViewController {
    
    
    var selectedMarkerId: Store?
    
    //var ref = DatabaseReference!()
    
    var nameValue: String!
    var addressValue: String!
    var phoneValue: String!
    var scorePeopleValue: Int!
    var longitudeValue: CLLocationDegrees!
    var latitudeValue: CLLocationDegrees!
    var storeScoreAverageValue: Double!
    
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
        
        guard let userLocation = self.currentLocation else { return }
        print("user位置\(userLocation)")
        guard let longitudeValue = longitudeValue else { return }
        print(234)
        guard let latitudeValue = latitudeValue else { return }
        print(456)
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(latitudeValue),\(longitudeValue)&directionsmode=walking")!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTotalRating()
        setUpStoreInfoWith()
        initLocationManager()
        
        
        if let latitudeValue = latitudeValue,
            let longitudeValue = longitudeValue {
            setUpMapView(latitude: latitudeValue,
                         longitude: longitudeValue)
        }
    }
    
    func setUpTotalRating() {
        
       guard let storeScoreAverageValue = storeScoreAverageValue else { return }

        
        // Change the cosmos view rating
        scoreAverageView.rating = storeScoreAverageValue
            
        scoreAverageView.settings.updateOnTouch = false
            
        // Set the distance between stars
        scoreAverageView.settings.starMargin = 5
            
        // Change the size of the stars
        scoreAverageView.settings.starSize = 40
        
    }
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
    
    private func setUpMapView(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: myMapView.bounds, camera: camera)
        //mapView.isMyLocationEnabled = true
        myMapView.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        endPosition = CLLocation(latitude: latitudeValue, longitude: longitudeValue)
        guard let nameValue = nameValue else { return }
        marker.title = nameValue
        marker.map = mapView
        marker.icon = #imageLiteral(resourceName: "bubbleNormal")

    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    private func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"

        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"

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

extension StoreInfoViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations.last!
        self.currentLocation = userLocation
        
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.frame.size = CGSize(width: 50, height: 50)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.sd_setImage(with: Auth.auth().currentUser?.photoURL,
                              placeholderImage: #imageLiteral(resourceName: "user-2"),
                              options: [],
                              completed: nil
        )
        
        marker.map = mapView
        marker.iconView = imageView
        
        if let end = endPosition {
            drawPath(startLocation: userLocation, endLocation: end)
        }

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}



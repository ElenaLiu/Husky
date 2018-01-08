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
    
    //MARK: Properties
    var selectedMarkerId: Store?
    
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

    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var scorePeopleLabel: UILabel!
    
    @IBOutlet weak var scoreAverageView: CosmosView!
    
    @IBOutlet weak var addressGuideTapped: UIButton!
    
    //MARK: Make phone call
    @IBAction func phoneCallTapped(_ sender: Any) {
        
        guard let phoneValue = phoneValue else { return }
        
        if let phoneCallURL = URL(string: "tel://\(phoneValue)") {
            
            UIApplication.shared.open(
                phoneCallURL,
                options: [:],
                completionHandler: nil
            )
        }
    }
    
    //MARK: Set up google guide
    @IBAction func addressGuideTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "「i Bubble」想要打開 「Google Maps」", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "打開", style: .default, handler: { (action) in
            
            guard let userLocation = self.currentLocation else { return }
            
            guard let longitudeValue = self.longitudeValue else { return }
            
            guard let latitudeValue = self.latitudeValue else { return }
            
            let googlemapsSchema = "comgooglemaps://"
            
            if (UIApplication.shared.canOpenURL(URL(string: googlemapsSchema)!)) {
                
                let url = URL(string:
                    "\(googlemapsSchema)?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(latitudeValue),\(longitudeValue)&directionsmode=walking")!
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                print("Can't use comgooglemaps://");
            }
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTotalRating()
        
        setUpStoreInfoWith()
        
        initLocationManager()
        
        if let latitudeValue = latitudeValue,
            let longitudeValue = longitudeValue {
            setUpMapView(
                latitude: latitudeValue,
                longitude: longitudeValue
            )
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
        
        if let addressValue = addressValue,
            let phoneValue = phoneValue,
            let scorePeopleValue = scorePeopleValue,
            let nameValue = nameValue{
            
            storeNameLabel.text = nameValue
            addressLabel.text = addressValue
            phoneLabel.text = phoneValue
            scorePeopleLabel.text = String(scorePeopleValue) + NSLocalizedString(" comment(s)", comment: "")
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

        let camera = GMSCameraPosition.camera(
            withLatitude: latitude,
            longitude: longitude,
            zoom: zoomLevel
        )
        
        self.mapView = GMSMapView.map(
            withFrame: myMapView.bounds,
            camera: camera
        )
        
        myMapView.addSubview(mapView)
        
        // Set up myMapView Constrain
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: myMapView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: myMapView.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: myMapView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: myMapView.bottomAnchor).isActive = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        endPosition = CLLocation(
            latitude: latitudeValue,
            longitude: longitudeValue
        )
        
        guard let nameValue = nameValue else { return }
        marker.title = nameValue
        marker.map = mapView
        marker.icon = #imageLiteral(resourceName: "DarkBubbleTea")
    }
    
    //MARK: Function for create direction path, from start location to desination location
    private func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        startLoading(status: "Loading")
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"

        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking"

        Alamofire.request(url).responseJSON { response in
            
            endLoading()
            
            let json = try! JSON(data: response.data!)
            
            let routes = json["routes"].arrayValue
            
            if routes == [] {
                let alert = UIAlertController(
                    title: "Oops!",
                    message: "Distance is too far, can't show the path.",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(
                        title: "Ok",
                        style: .default,
                        handler: nil
                    )
                )

                self.present(alert, animated: true, completion: nil)
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
        marker.position = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size = CGSize(width: 50, height: 50)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.sd_setImage(
            with: Auth.auth().currentUser?.photoURL,
            placeholderImage: #imageLiteral(resourceName: "user-2"),
            options: [],
            completed: nil
        )
        
        marker.map = mapView
        marker.iconView = imageView
        
        if let end = endPosition {
            drawPath(
                startLocation: userLocation,
                endLocation: end
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



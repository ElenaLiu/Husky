//
//  MapViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import SDWebImage
import Firebase




class MapViewController: UIViewController {
    
    @IBOutlet weak var myMapView: UIView!
    
    var storesInfo = [Store]()
    
    var locationMannager = CLLocationManager()
    var cruuentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 16.0
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLactionManager()
        
        setUpMapView()

        
        // fetch branches information
        StoreProvider.shared.delegate = self
        StoreProvider.shared.getStores()

    }
    func initLactionManager() {
        locationMannager = CLLocationManager()
        locationMannager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationMannager.requestAlwaysAuthorization()
        locationMannager.distanceFilter = 80
        locationMannager.startUpdatingLocation()
        locationMannager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        
    }
    func setUpMapView() {
        
        let camera = GMSCameraPosition.camera(
            withLatitude: 25.042995/*user location*/,
            longitude: 121.564988/*user location*/,
            zoom: zoomLevel)
        
        self.mapView = GMSMapView.map(
            withFrame: myMapView.bounds,
            camera: camera)
        
        mapView.isMyLocationEnabled = true
        myMapView.addSubview(mapView)
        mapView.delegate = self
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let marker = GMSMarker()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "user-2"))
        imageView.sd_setImage(with: Auth.auth().currentUser?.photoURL,
                              placeholderImage: #imageLiteral(resourceName: "Empty Tea"),
                              options: [],
                              completed: nil
        )
        marker.map = mapView
        marker.icon = UIImage(named: "whatsapp-3")
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
}



extension MapViewController: StoreProviderDelegate, GMSMapViewDelegate {
    func didFetch(with stores: [Store]) {
        
        self.storesInfo = stores
        
        for store in stores {
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D(latitude: store.latitude,
                                                     longitude: store.longitude)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.title = store.name
            marker.snippet = store.id
            marker.map = mapView
            marker.icon = #imageLiteral(resourceName: "ask")
  
        }
    }
    func didFail(with error: Error) {
        print(error)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        var didSelectedMarker: Store?
        
        for store in self.storesInfo {
            if store.id == marker.snippet {
                didSelectedMarker = store
                break
            }
        }
        let sb = UIStoryboard(name: "StoreDetailStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
        vc.selectedMarkerId = didSelectedMarker
        self.present(vc, animated: true, completion: nil)
        return true
    }
    
}


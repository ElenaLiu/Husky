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
    
    var ref: DatabaseReference!
    
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
        
        setUpNavigationBar()
        
        setUpMapView()

        // fetch branches information
        StoreProvider.shared.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading(status: "Loading")
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
    
    func setUpNavigationBar() {
        
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 28)!]
        navigationItem.title = "i Bubble"
    }
    
    func setUpMapView() {
        
        let camera = GMSCameraPosition.camera(
            withLatitude: 25.042995/*user location*/,
            longitude: 121.564988/*user location*/,
            zoom: zoomLevel)
        
        self.mapView = GMSMapView.map(
            withFrame: myMapView.bounds,
            camera: camera)
        
        myMapView.addSubview(mapView)
        mapView.delegate = self
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //get current location
        let location: CLLocation = locations.last!
        
        manager.stopUpdatingLocation()
        
        //set up marker
        let marker = GMSMarker()
        marker.position = location.coordinate
        
        //set up user marker image view
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size = CGSize(width: 40, height: 40)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.sd_setImage(with: Auth.auth().currentUser?.photoURL,
                              placeholderImage: #imageLiteral(resourceName: "user-2"),
                              options: [],
                              completed: nil
        )
        marker.iconView = imageView
        
        //put marker on the mapView
        marker.map = mapView
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
    }
}

extension MapViewController: StoreProviderDelegate, GMSMapViewDelegate {
    func didFetch(with stores: [Store]) {
        
        endLoading()
        self.storesInfo = stores
        
        for store in stores {
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D(
                latitude: store.latitude,
                longitude: store.longitude
            )
            
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.title = store.name
            marker.snippet = store.id
            ref = Database.database().reference()
            if let userId = Auth.auth().currentUser?.uid {
                ref.child("StoreComments").queryOrdered(byChild: "uid").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshotValue = snapshot.value,
                        let snapshotValueDics = snapshotValue as? [String: Any] {
                        for snapshotValueDic in snapshotValueDics {
                            if let valueDic = snapshotValueDic.value as? [String: Any],
                                let uidValue = valueDic["uid"] as? String,
                                let storeValue = valueDic["storeId"] as? String{
                                
                                if (userId == uidValue) && (store.id == storeValue){
                                    marker.icon = #imageLiteral(resourceName: "ColorfurBubbleTea")
                                } else {
                                    marker.icon = #imageLiteral(resourceName: "QStoreMarker")
                                }
                            }
                        }
                    }
                   marker.map = self.mapView
                })
            }
        }
    }
    func didFail(with error: Error) 
    {
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
        
        let storeInfoNavigationController = sb.instantiateViewController(withIdentifier: "StoreInfoNavigation") as! StoreDetailNavigationController
        storeInfoNavigationController.selectedMarkerId = didSelectedMarker
        self.present(storeInfoNavigationController, animated: true, completion: nil)
        return true
    }
    
}

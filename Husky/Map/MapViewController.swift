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

class MapViewController: UIViewController, GMUClusterManagerDelegate {

//    class BANGMUDefaultClusterIconGenerator: GMUDefaultClusterIconGenerator {
//        override func icon(forSize size: UInt) -> UIImage {
//            return #imageLiteral(resourceName: "BubbleTea(Brown)")
//        }
//    }
//
    

    
    //MARK: Properties
    @IBOutlet weak var myMapView: UIView!
    
    private var clusterManager: GMUClusterManager!
    private var mapView: GMSMapView!
    
    var ref: DatabaseReference!
    var storesInfo = [Store]()
    var locationMannager = CLLocationManager()
    var cruuentLocation: CLLocation?
//    var mapView: GMSMapView!
    var zoomLevel: Float = 16.0
    var selectedPlace: GMSPlace?
    
    //為獲得最佳效能，標記的建議數目上限為 10,000
    let kClusterItemCount = 10000
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()

        // fetch branches information
        StoreProvider.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading(status: "Loading")
        
        initLactionManager()
        
        setUpClusterManager()
        
        StoreProvider.shared.getStores()
    }
    
    func initLactionManager() {
        
        locationMannager = CLLocationManager()
        locationMannager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationMannager.requestAlwaysAuthorization()
        locationMannager.distanceFilter = 80
        locationMannager.delegate = self
        locationMannager.startUpdatingLocation()
        
    }
    
    func setUpNavigationBar() {
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.shadowImage = UIImage()
        navigationBar?.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 28)!
        ]
        navigationItem.title = "i Bubble"
    }
    
    func setUpMapView(location: CLLocation) {
        
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude/*user location*/,
            longitude: location.coordinate.longitude/*user location*/,
            zoom: zoomLevel)
        
        self.mapView = GMSMapView.map(
            withFrame: myMapView.bounds,
            camera: camera)
        
        
        
        myMapView.addSubview(mapView)
        mapView.delegate = self
    }
    
    // MARK: - GMUClusterManagerDelegate
    func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        print("didTapCluster cluster")
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                           zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("didTap clusterItem")
        return true
    }
    
    // MARK: - GMUMapViewDelegate
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            print("Did tap marker for cluster item \(poiItem.name)")
        } else {
            print("Did tap a normal marker")
        }
        return false
    }
    
    // Randomly generates cluster items within some extent of the camera and adds them to the
    // cluster manager.
    private func generateClusterItems(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String) {

            let lat = latitude
            let lng = longitude
            let name = name
            let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
            clusterManager.add(item)

       

    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    func setUpClusterManager() {
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        
        //renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //get current location
        let location: CLLocation = locations.last!
        
        manager.stopUpdatingLocation()
        
        setUpMapView(location: location)
        
        //set up marker
        let marker = GMSMarker()
        marker.position = location.coordinate
        
        //set up user marker image view
        let shadowView = UIView()
        shadowView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        shadowView.clipsToBounds = true
        shadowView.layer.cornerRadius = shadowView.frame.width / 2
        
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor(red: 76.0/255.0, green: 79.0/255.0, blue: 78.0/255.0, alpha: 1.0).cgColor
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.sd_setImage(with: Auth.auth().currentUser?.photoURL,
                              placeholderImage: #imageLiteral(resourceName: "user-2"),
                              options: [],
                              completed: nil)

        shadowView.addSubview(imageView)
        marker.iconView = shadowView
        
        //put marker on the mapView
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
}

extension MapViewController: StoreProviderDelegate, GMSMapViewDelegate {
    func didFetch(with stores: [Store]) {
        
        endLoading()
        self.storesInfo = stores

        for store in stores {
            let marker = GMSMarker()
         
            //set up user marker image view
            let shadowView = UIView()
            shadowView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            shadowView.clipsToBounds = true
            shadowView.layer.cornerRadius = shadowView.frame.width / 2
            
            shadowView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowView.layer.shadowOpacity = 1.0
            shadowView.layer.shadowRadius = 5
            shadowView.layer.shadowColor = UIColor(red: 76.0/255.0, green: 79.0/255.0, blue: 78.0/255.0, alpha: 1.0).cgColor
            
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
            imageView.layer.cornerRadius = imageView.frame.width / 2
            
            var la: CLLocationDegrees = store.latitude
            var lo: CLLocationDegrees = store.longitude
            // Generate and add random items to the cluster manager.
            generateClusterItems(latitude: store.latitude, longitude: store.longitude, name: store.name)
            
           
            
            marker.position = CLLocationCoordinate2D(
                latitude: store.latitude,
                longitude: store.longitude
            )
            
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        
            marker.title = store.name
            marker.snippet = store.id
            
            ref = NetworkingService.databaseRef
            
            if let userId = Auth.auth().currentUser?.uid {

                ref.child("StoreComments").queryOrdered(byChild: "uid").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshotValue = snapshot.value,
                        let snapshotValueDics = snapshotValue as? [String: Any] {
                        
                        for snapshotValueDic in snapshotValueDics {
                            if let valueDic = snapshotValueDic.value as? [String: Any],
                                let storeValue = valueDic["storeId"] as? String{
                                
                                if (store.id == storeValue) {
                                    imageView.image = #imageLiteral(resourceName: "ColorfurBubbleTea")
                                    break
                                } else {
                                    imageView.image = #imageLiteral(resourceName: "QStoreMarker")
                                }
                                
                            } else {
                                imageView.image = #imageLiteral(resourceName: "QStoreMarker")
                            }
                        }
                    }else {
                        imageView.image = #imageLiteral(resourceName: "QStoreMarker")
                    }
                    shadowView.addSubview(imageView)
                    marker.iconView = shadowView
                    marker.map = self.mapView
                })
            }
        }
    }
    
    func didFail(with error: StoreProviderError)
    {
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
   
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
//extension MapViewController: GMUClusterRendererDelegate {
//    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
//        print("willRenderMarker")
//    }
//    func renderer(_ renderer: GMUClusterRenderer, didRenderMarker marker: GMSMarker) {
//        print("didRenderMarker")
//    }
//    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
//        print("markerFor")
//        return GMSMarker()
//    }
//}


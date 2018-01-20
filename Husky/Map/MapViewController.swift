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
    
    //MARK: Properties
    @IBOutlet weak var myMapView: UIView!
    
<<<<<<< HEAD
    var reachability = Reachability(hostName: "www.apple.com")
=======
    private var clusterManager: GMUClusterManager!
    private var mapView: GMSMapView!
    
>>>>>>> clusterMapIcon
    var ref: DatabaseReference!
    var storesInfo = [Store]()
    var locationMannager = CLLocationManager()
    var cruuentLocation: CLLocation?
    var zoomLevel: Float = 16.0
    var selectedPlace: GMSPlace?
    
    var storeHasCommented: [[String: Bool]] = [] //ex. [storeId: true]
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading(status: "Loading")
        
        initLactionManager()
    }
    
    func initLactionManager() {
        
        locationMannager = CLLocationManager()
        locationMannager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationMannager.requestAlwaysAuthorization()
        locationMannager.distanceFilter = 80
        locationMannager.delegate = self
        locationMannager.startUpdatingLocation()
    }
    
    func checkInternetFunction() -> Bool {
        if reachability?.currentReachabilityStatus().rawValue == 0 {
            
            print("no internet connected.")
            return false
        }else {
            
            print("internet connected successfully.")
            return true
        }
    }
    
    func downloadData() {
        if checkInternetFunction() {
            
            print("internet connected successfully.")
            
        }else {
            endLoading()
            let alert = UIAlertController(
                title: "Oops!",
                message: "No internet connected! Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "Ok",
                    style: .cancel,
                    handler: {(_ action: UIAlertAction) -> Void in

                        self.dismiss(animated: true, completion: nil)
                }))

                self.present(alert, animated: true, completion: nil)
        }
    }

    
    func setUpNavigationBar() {
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.shadowImage = UIImage()
        navigationBar?.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 28)!
        ]
        navigationItem.title = "i Bubble"
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func setUpMapView(location: CLLocation) {
        
        checkInternetFunction()
        downloadData()

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
<<<<<<< HEAD
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //get current location
        let location: CLLocation = locations.last!
=======
    
    func setUpCluster() {
        
        // Set up the cluster manager with the supplied icon generator and
        // renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
>>>>>>> clusterMapIcon
        
        //set GMUDefaultClusterRenderer delegate to self.
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                           renderer: renderer)
        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        // clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    func setUpUserLocation(location: CLLocation) {
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
        marker.snippet = "UserMarker"
        marker.iconView = shadowView
        //put marker on the mapView
        marker.map = mapView
    }
    
    func setUpStoreData() {
        // fetch branches information
        StoreProvider.shared.delegate = self
        
        StoreProvider.shared.getStores()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //get current location
        let location: CLLocation = locations.last!
        
        manager.stopUpdatingLocation()
        
        setUpMapView(location: location)
        
        setUpCluster()
        
        setUpUserLocation(location: location)
        
        setUpStoreData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
}

extension MapViewController: StoreProviderDelegate {
    
    // Randomly generates cluster items within some extent of the camera and adds them to the
    // cluster manager.
    private func generateClusterItems(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String, storeId: String) {
        
        let item = POIItem(
            position: CLLocationCoordinate2DMake(latitude, longitude),
            name: name,
            storeId: storeId
        )
        clusterManager.add(item)
    }
    
    func didFetch(with stores: [Store]) {
        
        endLoading()
        self.storesInfo = stores
        
        for store in stores {
            
            // Generate and add random items to the cluster manager.
            generateClusterItems(latitude: store.latitude, longitude: store.longitude, name: store.name, storeId: store.id)
            
            self.storeHasCommented = []
            
            ref = NetworkingService.databaseRef
            
            if let userId = Auth.auth().currentUser?.uid {
                
                ref.child("StoreComments").queryOrdered(byChild: "uid").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshotValue = snapshot.value,
                        let snapshotValueDics = snapshotValue as? [String: Any] {
                        
                        for snapshotValueDic in snapshotValueDics {
                            if let valueDic = snapshotValueDic.value as? [String: Any],
                                let storeValue = valueDic["storeId"] as? String{
                                
                                if (store.id == storeValue) {
                                    self.storeHasCommented.append([store.id: true])
                                    break
                                }
                            }
                        }
                    }
                    
                    self.clusterManager.cluster()
                })
            }
        }
    }
    
    func didFail(with error: StoreProviderError) {
        let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: GMSMapViewDelegate, GMUClusterManagerDelegate {
    
    // MARK: - GMUClusterManagerDelegate
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        print("didTapCluster cluster")
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        
        return true
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("didTap clusterItem")
        
        return false
    }
    
    // MARK: - GMUMapViewDelegate
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker.snippet == "UserMarker" {
            return true
        }
        var didSelectedMarker: Store?
        
        if let poiItem = marker.userData as? POIItem {
            for store in self.storesInfo {
                if store.id == poiItem.storeId {
                    didSelectedMarker = store
                    break
                }
            }
            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            for store in self.storesInfo {
                if store.id == marker.snippet {
                    didSelectedMarker = store
                    break
                }
            }
            NSLog("Did tap normal mark")
        }
        
        let sb = UIStoryboard(name: "StoreDetailStoryboard", bundle: nil)
        
        let storeInfoNavigationController = sb.instantiateViewController(withIdentifier: "StoreInfoNavigation") as! StoreDetailNavigationController
        storeInfoNavigationController.selectedMarkerId = didSelectedMarker
        self.present(storeInfoNavigationController, animated: true, completion: nil)
        return true
    }
}

extension MapViewController: GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
        if let poiItem = marker.userData as? POIItem {
            
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
            
            //if clusterItem
            imageView.image = #imageLiteral(resourceName: "QStoreMarker")
            
            for dic in storeHasCommented {
                if dic[poiItem.storeId] == true {
                    imageView.image = #imageLiteral(resourceName: "ColorfurBubbleTea")
                    break
                }
            }
            shadowView.addSubview(imageView)
            marker.iconView = shadowView
        }
    }
}

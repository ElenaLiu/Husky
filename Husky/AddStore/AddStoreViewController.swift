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

class AddStoreViewController: UIViewController {
    
    @IBAction func addStoreTapped(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        present(placePicker, animated: true, completion: nil)
        
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()

//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//
//
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//
//
//
//        // Put the search bar in the navigation bar.
//        searchController?.searchBar.sizeToFit()
//        navigationItem.titleView = searchController?.searchBar
//
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        definesPresentationContext = true
//
//        // Prevent the navigation bar from being hidden when searching.
//        searchController?.hidesNavigationBarDuringPresentation = false
    }
    

    
//    func setUpGoogleSearchBar() {
//
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//
//        // Put the search bar in the navigation bar.
//        searchController?.searchBar.sizeToFit()
//        navigationItem.titleView = searchController?.searchBar
//
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        self.definesPresentationContext = true
//
//        // Prevent the navigation bar from being hidden when searching.
//        searchController?.hidesNavigationBarDuringPresentation = false
//    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 28)!]
        navigationItem.title = "i Bubble"
    }
}

//// Handle the user's selection.
//extension AddStoreViewController: GMSAutocompleteResultsViewControllerDelegate {
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didAutocompleteWith place: GMSPlace) {
//        searchController?.isActive = false
//        // Do something with the selected place.
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//    }
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didFailAutocompleteWithError error: Error){
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
////    }
//}


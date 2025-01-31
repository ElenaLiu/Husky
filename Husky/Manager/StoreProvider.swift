//
//  StoreProvider.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/14.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import Firebase
import GoogleMaps
import GooglePlaces

protocol StoreProviderDelegate: class {
    
    func didFetch(with stores: [Store])
    
    func didFail(with error: StoreProviderError)
}

enum StoreProviderError: Error {
    
    case fetchFail
    
    case infoError, addressError, phoneError, nameError
    
    case latitudeError, longitudeError, scoredPeopleError, storeScoreAverageError
}

class StoreProvider {
    
    static let shared = StoreProvider()
    
    weak var delegate: StoreProviderDelegate?
    
    func getStores() {
        NetworkingService.databaseRef.child("Stores").observeSingleEvent(of: .value) { (snapShot) in
            
            guard let storeDic = snapShot.value as? [String: Any] else { return }
            
            var stores = [Store]()
            
            for dicValue in storeDic {
                
                let id = dicValue.key
                
                guard
                    let info =  dicValue.value as? [String: Any] else {
                    self.delegate?.didFail(with: StoreProviderError.infoError)
                    return }
                guard let address = info[Store.Schema.address] as? String else {
                    self.delegate?.didFail(with: StoreProviderError.addressError)
                    return }
                guard let phone = info[Store.Schema.phone] as? String else {
                    self.delegate?.didFail(with: StoreProviderError.phoneError)
                    return }
                guard let name = info[Store.Schema.name] as? String else {
                    self.delegate?.didFail(with: StoreProviderError.nameError)
                    return }
                guard let latitude = info[Store.Schema.latitude] as? CLLocationDegrees else {
                    self.delegate?.didFail(with: StoreProviderError.latitudeError)
                    return }
                guard let longitude = info[Store.Schema.longitude] as? CLLocationDegrees else {
                    self.delegate?.didFail(with: StoreProviderError.longitudeError)
                    return }
                guard let scoredPeople = info[Store.Schema.scoredPeople] as? Int else {
                    self.delegate?.didFail(with: StoreProviderError.scoredPeopleError)
                    return }
                guard let storeScoreAverage = info[Store.Schema.storeScoreAverage] as? Double else {
                    self.delegate?.didFail(with: StoreProviderError.storeScoreAverageError)
                    return }
                
                stores.append(
                    Store(
                        id: id,
                        name: name,
                        address: address,
                        phone: phone,
                        longitude: longitude,
                        latitude: latitude,
                        scoredPeople: scoredPeople,
                        storeScoreAverage: storeScoreAverage
                    )
                )
            }
            self.delegate?.didFetch(with: stores)
        }
    }
    
    func saveStore(place: GMSPlace) {
        
        guard let address = place.formattedAddress,
            let phoneNumber = place.phoneNumber else { return }
        
        NetworkingService.databaseRef.child("Stores").childByAutoId().setValue([
                Store.Schema.name: place.name,
                Store.Schema.address: address,
                Store.Schema.phone: phoneNumber,
                Store.Schema.latitude: place.coordinate.latitude,
                Store.Schema.longitude: place.coordinate.longitude,
                Store.Schema.scoredPeople: 0,
                Store.Schema.storeScoreAverage: 0.0
                ])
    }
    
    func saveStoreWithoutGMSPlace(name: String, address: String, phone: String, location: CLLocation) {
    
        NetworkingService.databaseRef.child("Stores").childByAutoId().setValue([
            Store.Schema.name: name,
            Store.Schema.address: address,
            Store.Schema.phone: phone,
            Store.Schema.latitude: location.coordinate.latitude,
            Store.Schema.longitude: location.coordinate.longitude,
            Store.Schema.scoredPeople: 0,
            Store.Schema.storeScoreAverage: 0.0
            ])
    }
}

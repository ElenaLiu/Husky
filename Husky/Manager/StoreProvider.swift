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

protocol StoreProviderDelegate: class {
    
    func didFetch(with stores: [Store])
    
    func didFail(with error: Error)
    
}

class StoreProvider {
    
    static var ref: DatabaseReference = Database.database().reference()
    
    static let shared = StoreProvider()
    
    weak var delegate: StoreProviderDelegate?
    
    func getStores() {
        StoreProvider.ref.child("Stores").observeSingleEvent(of: .value) { (snapShot) in
            guard let storeDic = snapShot.value as? [String: Any] else { return }
            
            var stores = [Store]()
            for dicValue in storeDic {
                let id = dicValue.key
                guard let info =  dicValue.value as? [String: Any] else { return }
                guard let address = info[Store.Schema.address] as? String else { return }
                guard let phone = info[Store.Schema.phone] as? String else { return }
                guard let name = info[Store.Schema.name] as? String else { return }
                guard let latitude = info[Store.Schema.latitude] as? CLLocationDegrees else { return }
                guard let longitude = info[Store.Schema.longitude] as? CLLocationDegrees else { return }
                stores.append(
                    Store(
                        id: id,
                        name: name,
                        address: address,
                        phone: phone,
                        longitude: longitude,
                        latitude: latitude)
                )
            }
            self.delegate?.didFetch(with: stores)
        }
    }
}




//
//  StoreManager.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/14.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import Firebase
import GoogleMaps

public struct Store {
    
    // MARK: Schema
    
    public struct Schema {
        
        public static let id = "id"
        
        public static let name = "Name"
        
        public static let address = "Address"
        
        public static let phone = "Phone"
        
        public static let longitude = "longitude"
        
        public static let latitude = "latitude"
        
        

    }
    
    // MARK: Property
    
    public let id: String
    
    public let name: String
    
    public let address: String
    
    public let phone: String
    
    public let longitude: CLLocationDegrees
    
    public let latitude: CLLocationDegrees

}




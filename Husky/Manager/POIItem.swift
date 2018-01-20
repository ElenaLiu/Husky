//
//  POIItem.swift
//  Husky
//
//  Created by 劉芳瑜 on 2018/1/9.
//  Copyright © 2018年 Fang-Yu. Liu. All rights reserved.
//

import Foundation

class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var storeId: String!
    
    init(position: CLLocationCoordinate2D, name: String, storeId: String!) {
        self.position = position
        self.name = name
        self.storeId = storeId
    }
}


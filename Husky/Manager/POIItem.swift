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
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}

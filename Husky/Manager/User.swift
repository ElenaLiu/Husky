//
//  User.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/26.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

//Name User 會跟 firebase User重覆
public struct BubbleUser {
    
    // MARK: Schema
    
    public struct Schema {
        
        public static let uid = "uid"
        
        public static let userName = "username"
        
        public static let email = "email"
        
        public static let photoUrl = "photoUrl"

    }
    
    // MARK: Property
    
    public var uid: String
    
    public var userName: String
    
    public var email: String
    
    public var photoUrl: String

    
}




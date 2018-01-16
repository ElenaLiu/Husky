//
//  Comment.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/24.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import Foundation


public struct Comment {
    
    // MARK: Schema
    public struct Schema {
        
        public static let commentId = "commentId"
        
        public static let uid = "uid"
        
        public static let storeId = "storeId"
        
        public static let average = "average"
        
        public static let imageUrl = "imageUrl"
        
        public static let content = "content"
        
        public static let firstRating = "firstRating"
        
        public static let secondRating = "secondRating"
        
        public static let thirdRating = "thirdRating"
        
        public static let fourthRating = "fourthRating"
        
        public static let fifthRating = "fifthRating"
    }
    
    
    // MARK: Property
    public let commentId: String
    
    public let uid: String
    
    public let storeId: String
    
    public let average: Double
    
    public let imageUrl: String
    
    public let content: String
    
    public let firstRating: Double
    
    public let secondRating: Double
    
    public let thirdRating: Double
    
    public let fourthRating: Double
    
    public let fifthRating: Double
    
}

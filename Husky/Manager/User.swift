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

struct BubbleUser {

    var userName: String!
    var email: String!
    var uid: String!
    var photoUrl: String!
    var ref: DatabaseReference?
    var key: String

    init(snapshot: DataSnapshot){

        if let dictionary = snapshot.value as? [String: Any] {
            userName = dictionary["username"] as! String
            email = dictionary["email"] as! String
            photoUrl = dictionary["photoUrl"] as! String
        }
        key = snapshot.key
        ref = snapshot.ref
    }
}




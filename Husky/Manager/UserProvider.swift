////
////  UserProvider.swift
////  Husky
////
////  Created by 劉芳瑜 on 2018/1/1.
////  Copyright © 2018年 Fang-Yu. Liu. All rights reserved.
////
//
//import Foundation
//import Firebase
//

//protocol BubbleUserProviderDelegate: class {
//
//    func didFetch(with bubbleuser: BubbleUser)
//
//    func didFetch(with bubbleusers: [BubbleUser])
//
//    func didFail(with error: Error)
//}
//
//class BubbleUserProvider {
//
//    static let shared = BubbleUserProvider()
//
//    weak var delegate: BubbleUserProviderDelegate?
//
//    func fetchBubbleUser(uid: String) {
//        NetworkingService.databaseRef.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
//
//            guard let userDic = snapshot.value as? [String: String] else { return }
//
//            print(userDic)
//
//            let bubbleUser = BubbleUser(
//                uid: uid,
//                userName: userDic[BubbleUser.Schema.userName]!,
//                email: userDic[BubbleUser.Schema.email]!,
//                photoUrl: userDic[BubbleUser.Schema.photoUrl]!
//            )
//
//            self.delegate?.didFetch(with: bubbleUser)
//        }
//    }
//}


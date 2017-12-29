//
//  CommentProvider.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/28.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import Firebase


protocol CommentProviderDelegate: class {
    
    func didFetch(with comments: [Comment])
    
    func didFail(with error: Error)
}

class CommentProvider {
    
    static var ref: DatabaseReference = Database.database().reference()
    
    static let shared = CommentProvider()
    
    weak var delegate: CommentProviderDelegate?
    
    var selectedMarkerId: Store?
    
    var comments = [Comment]()
    
    
//    func fetchComments() {
//
//        let storeId = selectedMarkerId?.id
//
//        print("123\(selectedMarkerId)")
//
//
//        CommentProvider.ref.child("StoreComments").queryOrdered(byChild: "storeId").queryEqual(toValue: storeId).observeSingleEvent(of: .value) { (snapshot) in
//            print("455\(snapshot)")
//
//            guard let commentDic = snapshot.value as? [String: Any] else { return }
//
//            var comments = [Comment]()
//
//            for dicValue in commentDic {
//
//                guard let uid = Auth.auth().currentUser?.uid else { return }
//
//                guard let info =  dicValue.value as? [String: Any] else { return }
//                guard let storeId = info[Comment.Schema.storeId] as? String else { return }
//                guard let average = info[Comment.Schema.average] as? Double else { return }
//                guard let imageUrl = info[Comment.Schema.imageUrl] as? String else { return }
//                guard let content = info[Comment.Schema.content] as? String else { return }
//
//                print("124\(info)")
//
//
//                guard let scoreInfo = info["score"] as? [String: Any] else { return }
//                guard let firstRating = scoreInfo[Comment.Schema.firstRating] as? Double,
//                    let secondRating = scoreInfo[Comment.Schema.secondRating] as? Double,
//                    let thirdRating = scoreInfo[Comment.Schema.thirdRating] as? Double,
//                    let fourthRating = scoreInfo[Comment.Schema.fourthRating] as? Double,
//                    let fifthRating = scoreInfo[Comment.Schema.fifthRating] as? Double else { return }
//                print("135\(scoreInfo)")
//
//                comments.append(
//                    Comment(
//                        uid: uid,
//                        storeId: storeId,
//                        average: average,
//                        imageUrl: imageUrl,
//                        content: content,
//                        firstRating: firstRating,
//                        secondRating: secondRating,
//                        thirdRating: thirdRating,
//                        fourthRating: fourthRating,
//                        fifthRating: fifthRating
//                    )
//                )
//            }
//            self.delegate?.didFetch(with: comments)
//        }
//
//    }
}

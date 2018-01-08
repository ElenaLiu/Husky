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
    
    func didFail(with error: CommentProviderError)
}

enum CommentProviderError: Error {
    
    case noComment
}

class CommentProvider {
    
    //static 不用透過實體就可以呼叫
    static let shared = CommentProvider()
    
    weak var delegate: CommentProviderDelegate?
    
    var selectedMarkerId: Store?
    
    var comments = [Comment]()
    
    func fetchComments(selectStoreId: String) {

        let storeId = selectStoreId

NetworkingService.databaseRef.child("StoreComments").queryOrdered(byChild: "storeId").queryEqual(toValue: storeId).observeSingleEvent(of: .value) { (snapshot) in

            guard let commentDic = snapshot.value as? [String: Any] else {
                self.delegate?.didFail(with: CommentProviderError.noComment)
                return
            }

            var comments = [Comment]()

  
            for dicValue in commentDic {
                
                let commentId = dicValue.key

                guard let uid = Auth.auth().currentUser?.uid else { return }

                guard let info =  dicValue.value as? [String: Any],
                    let storeId = info[Comment.Schema.storeId] as? String,
                    let average = info[Comment.Schema.average] as? Double,
                    let imageUrl = info[Comment.Schema.imageUrl] as? String,
                    let content = info[Comment.Schema.content] as? String else { return }

                guard let scoreInfo = info["score"] as? [String: Any],
                    let firstRating = scoreInfo[Comment.Schema.firstRating] as? Double,
                    let secondRating = scoreInfo[Comment.Schema.secondRating] as? Double,
                    let thirdRating = scoreInfo[Comment.Schema.thirdRating] as? Double,
                    let fourthRating = scoreInfo[Comment.Schema.fourthRating] as? Double,
                    let fifthRating = scoreInfo[Comment.Schema.fifthRating] as? Double else { return }

                comments.append(
                    Comment(
                        commentId: commentId,
                        uid: uid,
                        storeId: storeId,
                        average: average,
                        imageUrl: imageUrl,
                        content: content,
                        firstRating: firstRating,
                        secondRating: secondRating,
                        thirdRating: thirdRating,
                        fourthRating: fourthRating,
                        fifthRating: fifthRating
                    )
                )
            }
            self.delegate?.didFetch(with: comments)
        }

    }
    
    func saveComment(comment: Comment, imageData: Data)
    {
        let key = NetworkingService.databaseRef.child("StoreComments").childByAutoId().key
        
        //Create Path for the User Image
        let commentImagePath = "commentImage\(key)/commentPic.jpg"
        
        // Create image Reference
        let imagesRef = NetworkingService.storageRef.child(commentImagePath)
        
        // Create Metadata for the image
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // Save the user Image in the Firebase Storage File
        imagesRef.putData(imageData,
                         metadata: metaData) { (metaData, error) in
                            if error == nil {
                                let imageUrl = metaData!.downloadURL()
                                
                                self.saveCommentInfo(comment: comment, imageUrl: imageUrl, key: key)
                            }else {
                                print(error!.localizedDescription)
                            }
        }
    }
    
    private func saveCommentInfo(comment: Comment, imageUrl: URL?, key: String) {

        NetworkingService.databaseRef.child("StoreComments").child(key).setValue([
            "uid": comment.uid,
            "storeId": comment.storeId,
            "average": comment.average,
            "content": comment.content,
            "imageUrl": imageUrl?.absoluteString,
            "score": ["firstRating": comment.firstRating,
                      "secondRating": comment.secondRating,
                      "thirdRating": comment.thirdRating,
                      "fourthRating": comment.fourthRating,
                      "fifthRating": comment.fifthRating]
            ])
        endLoading()
    }
}

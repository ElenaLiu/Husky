//
//  CommentsTableViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import FoldingCell
import Firebase

class CommentsTableViewController: UITableViewController, CommentProviderDelegate {
    
    var selectedMarkerId: Store?
    
    var comments = [Comment]()
    
    func didFetch(with comments: [Comment]) {
        
        
    }
    
    func didFail(with error: Error) {
        
    }


    
//    let kCloseCellHeight: CGFloat = 179
//    let kOpenCellHeight: CGFloat = 488
//    let kRowsCount = 10
//    var cellHeights: [CGFloat] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch stores information
        //CommentProvider.shared.delegate = self
        
        guard let selectedStore = selectedMarkerId else { return }
        print("777\(selectedStore)")
        
        fetchComments()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //CommentProvider.shared.fetchComments()
    }
    
    func fetchComments() {
        
        let storeId = selectedMarkerId?.id
        
        print("123\(selectedMarkerId)")
        
        
        CommentProvider.ref.child("StoreComments").queryOrdered(byChild: "storeId").queryEqual(toValue: storeId).observeSingleEvent(of: .value) { (snapshot) in
            print("455\(snapshot)")
            
            guard let commentDic = snapshot.value as? [String: Any] else { return }
            
            var comments = [Comment]()
            
            for dicValue in commentDic {
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                guard let info =  dicValue.value as? [String: Any] else { return }
                guard let storeId = info[Comment.Schema.storeId] as? String else { return }
                guard let average = info[Comment.Schema.average] as? Double else { return }
                guard let imageUrl = info[Comment.Schema.imageUrl] as? String else { return }
                guard let content = info[Comment.Schema.content] as? String else { return }
                
                print("124\(info)")
                
                
                guard let scoreInfo = info["score"] as? [String: Any] else { return }
                guard let firstRating = scoreInfo[Comment.Schema.firstRating] as? Double,
                    let secondRating = scoreInfo[Comment.Schema.secondRating] as? Double,
                    let thirdRating = scoreInfo[Comment.Schema.thirdRating] as? Double,
                    let fourthRating = scoreInfo[Comment.Schema.fourthRating] as? Double,
                    let fifthRating = scoreInfo[Comment.Schema.fifthRating] as? Double else { return }
                print("135\(scoreInfo)")
                
                comments.append(
                    Comment(
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
        }
    }
    
//    private func fetchComment() {
//
//        let storeId = selectedMarkerId?.id
//
//        netWordingService.databaseRef.child("StoreComments").queryOrdered(byChild: "storeId").queryEqual(toValue: storeId).observe(.value) { [weak self] (snapshot) in
//            print("234\(storeId)")
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            guard let uid = dictionary["uid"] as? String,
//                let storeId = dictionary["storeId"] as? String,
//                let average = dictionary["average"] as? Double,
//                let imageData = dictionary["imageData"] as? Data,
//                let content = dictionary["content"] as? String else { return }
//            print("2783\(dictionary)")
//
//
//            guard let scoreValue = dictionary["score"] as? [String: AnyObject] else { return }
//            guard let firstRating = scoreValue["firstRating"] as? Double,
//                let secondRating = scoreValue["secondRating"] as? Double,
//                let thirdRating = scoreValue["thirdRating"] as? Double,
//                let fourthRating = scoreValue["fourthRating"] as? Double,
//                let fifthRating = scoreValue["fifthRating"] as? Double else { return }
//            print("347\(scoreValue)")
//
//
//                let comment = Comment(uid: uid, storeId: storeId, average: average, imageData: imageData, content: content, firstRating: firstRating, secondRating: secondRating, thirdRating: thirdRating, fourthRating: fourthRating, fifthRating: fifthRating)
//
//
//            self?.comments.append(comment)
//
//        }
//
//
//    }
    
//    private func setup() {
//        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
//        tableView.estimatedRowHeight = kCloseCellHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
////        tableView.backgroundColor = UIColor()
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        print("222\(comments)")
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        let comment = comments[indexPath.row]
        print("333\(comment)")
        cell.textLabel?.text = comment.content

        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

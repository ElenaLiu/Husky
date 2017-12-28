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
    
    func didFetch(with comments: [Comment]) {
        
    }
    func didFail(with error: Error) {
        
    }
    
    let netWordingService = NetworkingService()
    
    var selectedMarkerId: Store?
    
    var comments = [Comment]()

    
//    let kCloseCellHeight: CGFloat = 179
//    let kOpenCellHeight: CGFloat = 488
//    let kRowsCount = 10
//    var cellHeights: [CGFloat] = []
//
//

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch stores information
        CommentProvider.shared.delegate = self
        
        guard let selectedStore = selectedMarkerId else { return }
        
//        fetchComment()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CommentProvider.shared.fetchComments()
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
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell

        

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

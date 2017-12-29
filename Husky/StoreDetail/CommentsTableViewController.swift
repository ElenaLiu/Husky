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

class CommentsTableViewController: UITableViewController {
    
    var selectedMarkerId: Store?
    
    var comments = [Comment]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch stores information
        CommentProvider.shared.delegate = self
        
        guard let selectedStore = selectedMarkerId else { return }
        print("777\(selectedStore)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CommentProvider.shared.fetchComments(selectStoreId: (selectedMarkerId?.id)!)
        
    }
    

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
        cell.label?.text = comment.content

        

        return cell
    }
}
extension CommentsTableViewController: CommentProviderDelegate {
    
    func didFetch(with comments: [Comment]) {
        
        self.comments = comments
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFail(with error: Error) {
        
    }
}



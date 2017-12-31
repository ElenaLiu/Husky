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
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 130
            static let open: CGFloat = 210
        }
    }
    
    //Add property for calculate cells height
    var cellHeights = (0..<2).map { _ in C.CellHeight.close }
    
    var selectedMarkerId: Store?
    
    var comments = [Comment]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch stores information
        CommentProvider.shared.delegate = self
        
        guard let selectedStore = selectedMarkerId else { return }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CommentProvider.shared.fetchComments(selectStoreId: (selectedMarkerId?.id)!)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == C.CellHeight.close { // open cell
            cellHeights[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as CommentsTableViewCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                cell.unfold(false, animated: false, completion:nil)
            } else {
                cell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        let comment = comments[indexPath.row]

        

        

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



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
import SDWebImage
import SCLAlertView

class CommentsTableViewController: UITableViewController {
    
    @IBOutlet weak var noCommentAlertLable: UILabel!
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 199
            static let open: CGFloat = 510
        }
    }
    
    //Add property for calculate cells height
    var cellHeights: [CGFloat] = []
    
    var selectedMarkerId: Store?
  
    var comments = [Comment]()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // fetch stores information
        CommentProvider.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if checkInternetFunction() == false {
            return
        }
        
        startLoading(status: "Loading")

        CommentProvider.shared.fetchComments(selectStoreId: (selectedMarkerId?.id)!)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard case let cell as CommentsTableViewCell = tableView.cellForRow(at: indexPath) else {
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
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        
        let comment = comments[indexPath.row]
        
        // Trainsition String type to be URL
        let photoUrl = URL(string: comment.imageUrl)
     
        if photoUrl != nil {
            cell.foregroundBlurImageView.sd_setImage(with: photoUrl, completed: nil)
            cell.foregroundImageView.sd_setImage(with: photoUrl, completed: nil)
            cell.containerBlurImageView.sd_setImage(with: photoUrl, completed: nil)
            cell.containerImageView.sd_setImage(with: photoUrl, completed: nil)
        } else {
            cell.foregroundBlurImageView.image = #imageLiteral(resourceName: "BubbleTea(Brown)")
            cell.foregroundBlurImageView.contentMode = .scaleAspectFit
            cell.foregroundImageView.image = #imageLiteral(resourceName: "BubbleTea(Brown)")
            cell.foregroundImageView.contentMode = .scaleAspectFit
            cell.containerBlurImageView.image = #imageLiteral(resourceName: "BubbleTea(Brown)")
            cell.containerBlurImageView.contentMode = .scaleAspectFit
            cell.containerImageView.image = #imageLiteral(resourceName: "BubbleTea(Brown)")
            cell.containerImageView.contentMode = .scaleAspectFit
        }

        let commentUid = comment.uid
        NetworkingService.databaseRef.child("Users").queryOrdered(byChild: BubbleUser.Schema.uid).queryEqual(toValue: commentUid).observeSingleEvent(of: .value) { (snapshot) in
           
            guard let userDic = snapshot.value as? [String: Any] else { return }
            
            for value in userDic.values {
                guard let valueDic = value as? [String: String] else { return }
                guard let username = valueDic[BubbleUser.Schema.userName] else { return }
                guard let photoUrl = valueDic[BubbleUser.Schema.photoUrl] else { return }
               
                print("6 \(username)")
                print("66 \(photoUrl)")
                
                DispatchQueue.main.async {
                    // Trainsition String type to be URL
                    let userPhotoUrl = URL(string: photoUrl)
                    cell.userImageView.sd_setImage(with: userPhotoUrl, completed: nil)
                    
                    cell.userNameLabel.text = username
                }
            }
        }
        return cell
    }
}

extension CommentsTableViewController: CommentProviderDelegate {
    
    func didFetch(with comments: [Comment]) {
        
        endLoading()
        self.comments = comments
        
        DispatchQueue.main.async {
            
            self.cellHeights = (0..<comments.count).map { _ in C.CellHeight.close }
            self.tableView.reloadData()
        }
    }
    
    func didFail(with error: CommentProviderError) {
        
        endLoading()
        if error == CommentProviderError.noComment {
            
            noCommentAlertLable.isHidden = false
        }
        
        if error == CommentProviderError.uploadImageFail {
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: Fonts.SentyWen16,
                kTextFont: Fonts.SentyWen16,
                kButtonFont: Fonts.SentyWen16,
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton(
                NSLocalizedString("Ok ", comment: ""),
                action: {
            })
            
            alertView.showError(
                "Error!",
                subTitle: error.localizedDescription
            )
        }
    }
}


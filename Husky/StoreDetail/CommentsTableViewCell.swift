//
//  CommentsTableViewCell.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/15.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import FoldingCell
import Cosmos


class CommentsTableViewCell: FoldingCell {
    
    @IBOutlet weak var firstRatingView: CosmosView!
    
    @IBOutlet weak var secondRatingView: CosmosView!
    
    @IBOutlet weak var thirdRatingView: CosmosView!
    
    @IBOutlet weak var fourthRatingView: CosmosView!

    @IBOutlet weak var fifthRatingView: CosmosView!
    
    @IBOutlet weak var foregroundImageView: UIImageView!
    
    @IBOutlet weak var containerImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userCommentTextField: UITextView!
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 20
        foregroundView.layer.masksToBounds = true
        setUpRating()
        //code 要加在 super 上面
        super.awakeFromNib()
        
    }
    
    func setUpRating() {

        firstRatingView.settings.updateOnTouch = false
        secondRatingView.settings.updateOnTouch = false
        thirdRatingView.settings.updateOnTouch = false
        fourthRatingView.settings.updateOnTouch = false
        fifthRatingView.settings.updateOnTouch = false
    }
}


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
    
    @IBOutlet weak var firstScoreLabel: UILabel!
    @IBOutlet weak var firstRatingView: CosmosView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var foregroundImageView: UIImageView!
    
    @IBOutlet weak var containerImageView: UIImageView!

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 20
        foregroundView.layer.masksToBounds = true
    
        setUpFirstRating()
        //code 要加在 super 上面
        super.awakeFromNib()
        
        
    }
    
    func setUpFirstRating() {

        firstRatingView.settings.updateOnTouch = false
        
        // Set the distance between stars
        firstRatingView.settings.starMargin = 5
        
        // Change the size of the stars
        firstRatingView.settings.starSize = 40
        
    }
    
    
//    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
//        
//        // durations count equal it itemCount
//        let durations = [0.33, 0.26, 0.26] // timing animation for each view
//        return durations[itemIndex]
//    }
}

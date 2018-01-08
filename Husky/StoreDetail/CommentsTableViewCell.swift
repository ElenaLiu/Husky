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
    
    //MARK: Properties
    @IBOutlet weak var firstRatingView: CosmosView!
    
    @IBOutlet weak var secondRatingView: CosmosView!
    
    @IBOutlet weak var thirdRatingView: CosmosView!
    
    @IBOutlet weak var fourthRatingView: CosmosView!

    @IBOutlet weak var fifthRatingView: CosmosView!
    
    @IBOutlet weak var foregroundBlurImageView: UIImageView!
    
    @IBOutlet weak var foregroundImageView: UIImageView!
    
    @IBOutlet weak var containerBlurImageView: UIImageView!
    
    @IBOutlet weak var containerImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userCommentTextField: UITextView!

    override func awakeFromNib() {

        setUpRating()
        setUpUserImage()
        setUpFoldingCellLayer()
        setUpForegroundBlurImageView()
        setUpContainerBlurImageView()
        
        self.backViewColor = UIColor.gray
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
    
    func setUpUserImage() {
        
        self.userImageView.layer.borderWidth = 0
        self.userImageView.layer.masksToBounds = false
        self.userImageView.frame.size = CGSize(width: 50, height: 50)
        self.userImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.userImageView.layer.cornerRadius = userImageView.bounds.size.height / 2.0
        self.userImageView.clipsToBounds = true
    }
    
    func setUpFoldingCellLayer() {
        
        self.foregroundImageView.layer.borderWidth = 0
        self.foregroundImageView.layer.masksToBounds = true
        self.foregroundImageView.layer.cornerRadius = 20
        self.foregroundImageView.clipsToBounds = true
        
        self.foregroundBlurImageView.layer.borderWidth = 0
        self.foregroundBlurImageView.layer.masksToBounds = true
        self.foregroundBlurImageView.layer.cornerRadius = 20
        self.foregroundBlurImageView.clipsToBounds = true
        
        self.containerBlurImageView.layer.borderWidth = 0
        self.containerBlurImageView.layer.masksToBounds = true
        self.containerBlurImageView.layer.cornerRadius = 20
        self.containerBlurImageView.clipsToBounds = true
    }
    
    func setUpForegroundBlurImageView() {
        //建立模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //建立乘載模糊效果的圖
        let blurView = UIVisualEffectView(effect: blurEffect)
        //添加模糊圖片到view上（圖片下方都會有模糊的效果）
        self.foregroundBlurImageView.addSubview(blurView)
        
        //設置模糊效果圖片範圍
        // Add Auto Layout for blurView
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.leadingAnchor.constraint(equalTo: foregroundView.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: foregroundView.trailingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: foregroundView.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: foregroundView.bottomAnchor).isActive = true
    }
    
    func setUpContainerBlurImageView() {
        //建立模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //建立乘載模糊效果的圖
        let blurView = UIVisualEffectView(effect: blurEffect)
        //添加模糊圖片到view上（圖片下方都會有模糊的效果）
        self.containerBlurImageView.addSubview(blurView)
        
        //設置模糊效果圖片範圍
        // Add Auto Layout for blurView
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}


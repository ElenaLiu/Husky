//
//  ScoreViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import Cosmos

class ScoreViewController: UIViewController {

    @IBOutlet weak var firstRatingView: CosmosView!
    @IBOutlet weak var secondRatingView: CosmosView!
    @IBOutlet weak var thirdRatingView: CosmosView!
    @IBOutlet weak var fourthRatingView: CosmosView!
    @IBOutlet weak var fifthRatingView: CosmosView!
    @IBOutlet weak var commentTextField: UITextView!
    
    @IBAction func saveScoreTapped(_ sender: Any) {
    }
    
    var firstRating: Double = 0.0
    var secondRating: Double = 0.0
    var thirdRating: Double = 0.0
    var fourthRating: Double = 0.0
    var fifthRating: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFirstRating()
        setUpSecondRating()
        setUpthirdRating()
        setUpfourthRating()
        setUpfifthRating()
    }
    
    func setUpFirstRating() {
        // Change the cosmos view rating
        firstRatingView.rating = 0
        
        // Change the text
        //firstRatingView.text = String(ratingView.rating)
        
        firstRatingView.didFinishTouchingCosmos = { rating in
            print("didFinishTouchingCosmos")
            print(rating)
            self.firstRating = rating
        }

    }
    
    func setUpSecondRating() {
        secondRatingView.rating = 0
        secondRatingView.didFinishTouchingCosmos = { rating in
            self.secondRating = rating
        }
    }
    
    func setUpthirdRating() {
        thirdRatingView.rating = 0
        thirdRatingView.didFinishTouchingCosmos = { rating in
            self.thirdRating = rating
        }
    }
    
    func setUpfourthRating() {
        fourthRatingView.rating = 0
        fourthRatingView.didFinishTouchingCosmos = { rating in
            self.fourthRating = rating
        }
    }
    
    func setUpfifthRating() {
        fifthRatingView.rating = 0
        fifthRatingView.didFinishTouchingCosmos = { rating in
            self.fifthRating = rating
        }
    }
    
    
}

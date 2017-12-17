//
//  ScoreViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/13.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import Cosmos
import Firebase


class ScoreViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var firstRatingView: CosmosView!
    @IBOutlet weak var secondRatingView: CosmosView!
    @IBOutlet weak var thirdRatingView: CosmosView!
    @IBOutlet weak var fourthRatingView: CosmosView!
    @IBOutlet weak var fifthRatingView: CosmosView!
    @IBOutlet weak var commentTextField: UITextView!
    
    @IBOutlet weak var scoreScrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scoreScrollView: UIScrollView!
    var firstRating: Double = 0.0
    var secondRating: Double = 0.0
    var thirdRating: Double = 0.0
    var fourthRating: Double = 0.0
    var fifthRating: Double = 0.0
    
    
    @IBAction func saveScoreTapped(_ sender: Any) {
        
        guard let comment = commentTextField.text else { return }
        
        let average =
            (firstRating + secondRating + thirdRating + fourthRating + fifthRating)
                / 5
       
        ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            
            self.ref.child("Comments").setValue([
                "uid": uid,
                "average": average,
                "comment": comment,
                "score": ["firstRating": firstRating,
                          "secondRating": secondRating,
                          "thirdRating": thirdRating,
                          "fourthRating": fourthRating,
                          "fifthRating": fifthRating]
                ])
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFirstRating()
        setUpSecondRating()
        setUpthirdRating()
        setUpfourthRating()
        setUpfifthRating()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //tap anywhere to hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    
    }
    // Remove observer
    deinit {
         let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
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
    
    // Handling keyboard
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardCGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardCGRect.height, right: 0)
        scoreScrollView.contentInset = contentInsets
        scoreScrollView.scrollRectToVisible(keyboardCGRect, animated: true)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        scoreScrollView.contentInset = UIEdgeInsets.zero

    }
    
    @objc func dismissKeyboard() {
        
        commentTextField.resignFirstResponder()
        
    }
}

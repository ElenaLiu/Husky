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
import Fusuma
import SCLAlertView

class ScoreViewController: UIViewController, FusumaDelegate, UITextViewDelegate {
    
    //MARK: Properties
    let networkingService = NetworkingService()
    
    var ref: DatabaseReference!
    
    var selectedMarkerId: Store?

    var isSetImage: Bool = false
    
    @IBOutlet weak var scoreImageView: UIImageView!
    
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
    
    @IBOutlet weak var saveScoreButton: UIButton!
    
    //MARK: Save score
    @IBAction func saveScoreTapped(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: Fonts.SentyWen16,
            kTextFont: Fonts.SentyWen16,
            kButtonFont: Fonts.SentyWen16,
            showCloseButton: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton(
            NSLocalizedString("Ok", comment: ""),
            action: {
        })
        
        if self.firstRatingView.rating == 0 {
            alertView.showInfo("", subTitle: NSLocalizedString("B chewy haven't score, please score before send.", comment: ""))
            return
        } else if self.secondRatingView.rating == 0 {
            alertView.showInfo("", subTitle: NSLocalizedString("B flavor haven't score, please score before send.", comment: ""))
            return
        } else if self.thirdRatingView.rating == 0 {
            alertView.showInfo("", subTitle: NSLocalizedString("B Qty haven't score, please score before send.", comment: ""))
            return
        } else if self.fourthRatingView.rating == 0 {
            alertView.showInfo("", subTitle: NSLocalizedString("T flavor haven't score, please score before send.", comment: ""))
            return
        } else if self.fifthRatingView.rating == 0 {
            alertView.showInfo("", subTitle: NSLocalizedString("Service haven't score, please score before send.", comment: ""))
            return
        }
        
        let imageData = UIImageJPEGRepresentation(self.scoreImageView.image!, 0.8)
        
        guard let content = commentTextField.text else { return }
        guard let selectedStore = selectedMarkerId else { return }
        
        let newAverage =
            (firstRating + secondRating + thirdRating + fourthRating + fifthRating)
                / 5

        let averageTotal = (selectedStore.storeScoreAverage * Double(selectedStore.scoredPeople)) + newAverage
        
        let scoreAverage = averageTotal / Double(selectedStore.scoredPeople + 1)

        ref = NetworkingService.databaseRef
        if let uid = Auth.auth().currentUser?.uid {
            
            let comment = Comment(
                commentId: "",
                uid: uid,
                storeId: selectedStore.id,
                average: newAverage,
                imageUrl: "",
                content: content,
                firstRating: firstRating,
                secondRating: secondRating,
                thirdRating: thirdRating,
                fourthRating: fourthRating,
                fifthRating: fifthRating
            )
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: Fonts.SentyWen16,
                kTextFont: Fonts.SentyWen16,
                kButtonFont: Fonts.SentyWen16,
                showCloseButton: false
            )
            
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton(
                NSLocalizedString("Yes ", comment: ""),
                action: {
                    startLoading(status: "Loading")
                    
                    if self.isSetImage {
                        CommentProvider.shared.saveComment(comment: comment, imageData: imageData!)
                    } else {
                        CommentProvider.shared.saveComment(comment: comment, imageData: nil)
                    }
                    
                    let storeRef = self.ref.child("Stores").child(selectedStore.id)
                    let stores = ["scoredPeople": selectedStore.scoredPeople + 1 , "storeScoreAverage": scoreAverage] as [String : Any]
                    storeRef.updateChildValues(stores)
        
                    self.firstRatingView.rating = 0
                    self.secondRatingView.rating = 0
                    self.thirdRatingView.rating = 0
                    self.fourthRatingView.rating = 0
                    self.fifthRatingView.rating = 0
                    self.commentTextField.text = NSLocalizedString("Leave some comment.....", comment: "")
                    self.scoreImageView.image = #imageLiteral(resourceName: "PhotoCamera")
                    self.scoreImageView.contentMode = .center
            })
            
            alertView.addButton(
                NSLocalizedString("No ", comment: ""),
                action: {
            })
            
            alertView.showEdit(
                "",
                subTitle: NSLocalizedString("Send comment?", comment: "")
            )
        }
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScoreImage()
        setUpSaveScoreButton()
        saveScoreButton.setGradient(colorOne: Colors.pinkyred, colorTwo: Colors.lightpinkyred)
        setUpCommentTextField()
        setUpFirstRating()
        setUpSecondRating()
        setUpthirdRating()
        setUpfourthRating()
        setUpfifthRating()
        
        commentTextField.delegate = self
        commentTextField.text = NSLocalizedString("Leave some comment.....", comment: "")
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        commentTextField.text = ""
    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        commentTextField.text = NSLocalizedString("Leave some comment.....", comment: "")
//    }
    //MARK: Pick up photo
    func setUpScoreImage() {
        
        self.scoreImageView.layer.borderWidth = 0
        self.scoreImageView.layer.cornerRadius = 10
        self.scoreImageView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhotoAction))
        
        self.scoreImageView.addGestureRecognizer(tap)
        self.scoreImageView.isUserInteractionEnabled = true

    }
    
    @objc func takePhotoAction() {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        isSetImage = true
        self.scoreImageView.image = image
        self.scoreImageView.contentMode = .scaleAspectFill
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    
    func fusumaCameraRollUnauthorized() {}
    
    func setUpSaveScoreButton() {
        
        self.saveScoreButton.layer.borderWidth = 0
        self.saveScoreButton.layer.cornerRadius = 30
        self.saveScoreButton.clipsToBounds = true
    }
    
    func setUpCommentTextField() {
        
        self.commentTextField.layer.borderWidth = 0
        self.commentTextField.layer.cornerRadius = 20
        self.commentTextField.clipsToBounds = true
    }
    
    func setUpFirstRating() {
        // Change the cosmos view rating
        firstRatingView.rating = 0

        // Set the distance between stars
        firstRatingView.settings.starMargin = 10
        
        // Change the size of the stars
        firstRatingView.settings.starSize = 30
        
        firstRatingView.didTouchCosmos = { rating in
            self.firstRating = rating
        }
    }
    
    func setUpSecondRating() {
        secondRatingView.rating = 0
        // Set the distance between stars
        secondRatingView.settings.starMargin = 10
        // Change the size of the stars
        secondRatingView.settings.starSize = 30
        secondRatingView.didTouchCosmos = { rating in
            self.secondRating = rating
        }
    }
    
    func setUpthirdRating() {
        thirdRatingView.rating = 0
        // Set the distance between stars
        thirdRatingView.settings.starMargin = 10
        // Change the size of the stars
        thirdRatingView.settings.starSize = 30
        
        thirdRatingView.didTouchCosmos = { rating in
            self.thirdRating = rating
        }
    }
    
    func setUpfourthRating() {
        fourthRatingView.rating = 0
        // Set the distance between stars
        fourthRatingView.settings.starMargin = 10
        // Change the size of the stars
        fourthRatingView.settings.starSize = 30
        fourthRatingView.didTouchCosmos = { rating in
            self.fourthRating = rating
        }
    }
    
    func setUpfifthRating() {
        
        fifthRatingView.rating = 0
        // Set the distance between stars
        fifthRatingView.settings.starMargin = 10
        // Change the size of the stars
        fifthRatingView.settings.starSize = 30
        fifthRatingView.didTouchCosmos = { rating in
            self.fifthRating = rating
        }
    }
    
    // Handling keyboard
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardCGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardCGRect.height - 80, right: 0)
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

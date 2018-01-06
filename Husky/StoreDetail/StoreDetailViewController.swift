//
//  StoreDetailViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/15.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {
    
    let textView = UITextView()
    
    var isHigitLighted: Bool = false
    
    var selectedMarkerId: Store?
    
    var StoreInfoViewController: StoreInfoViewController!
    
    var selectedViewController: UIViewController!
    
    lazy var CommentsTableViewController: CommentsTableViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "CommentsTableViewController") as! CommentsTableViewController
    }()
    
    lazy var ScoreViewController: ScoreViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
    }()
    
    @IBOutlet weak var storeInfoPageTapped: UIButton!
    
    @IBOutlet weak var scorePageTapped: UIButton!
    
    @IBOutlet weak var commentsPageTapped: UIButton!
    
    @IBAction func showStoreInfoPageTapped(_ sender: Any) {
        
        if let navigationController = self.navigationController as? StoreDetailNavigationController {

            StoreInfoViewController.selectedMarkerId = navigationController.selectedMarkerId

            changePage(to: StoreInfoViewController)
        }
    }
    
    @IBAction func showScorePageTapped(_ sender: Any) {
        
        if let navigationController = self.navigationController as? StoreDetailNavigationController {
        
            ScoreViewController.selectedMarkerId = navigationController.selectedMarkerId
        
            changePage(to: ScoreViewController)
        }
    }
    
    @IBAction func showCommentsPageTapped(_ sender: Any) {
        
        if let navigationController = self.navigationController as? StoreDetailNavigationController {
        
            CommentsTableViewController.selectedMarkerId = navigationController.selectedMarkerId
            
            changePage(to: CommentsTableViewController)
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationController = self.navigationController as! StoreDetailNavigationController
        
        self.selectedMarkerId = navigationController.selectedMarkerId
        
        // SetUp navigationBar
        setUpNavigationBar()
        
        // SetUp default page
        selectedViewController = StoreInfoViewController
        self.storeInfoPageTapped.setTitleColor(Colors.seaGreen, for: .normal)
        
    }
    
    @IBAction func backToMapPageTapped(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpNavigationBar() {
        
        //navigationItem.title = selectedMarkerId?.name
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Papyrus", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
//        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "GreenBubbleTea"))
//        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        navigationItem.titleView = titleImageView
//
        let textView = UITextView()
        textView.text = "i Bubble"
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "Chalkduster", size: 25)
        textView.textAlignment = .center
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false

        textView.sizeToFit()
        navigationItem.titleView = textView 
    }
    
    func changePage(to newViewController: UIViewController) {
        
        if newViewController is StoreInfoViewController {

            self.storeInfoPageTapped.setTitleColor(Colors.seaGreen, for: .normal)
        } else {
            self.storeInfoPageTapped.setTitleColor(UIColor.darkGray, for: .normal)
        }
        if newViewController is ScoreViewController {
            
            self.scorePageTapped.setTitleColor(Colors.seaGreen, for: .normal)
        } else {
            self.scorePageTapped.setTitleColor(UIColor.darkGray, for: .normal)
        }
        
        if newViewController is CommentsTableViewController {
            
            self.commentsPageTapped.setTitleColor(Colors.seaGreen, for: .normal)
        } else {
            self.commentsPageTapped.setTitleColor(UIColor.darkGray, for: .normal)
        }
//        if newViewController is ScoreViewController {
//
//            let cameraTapped = UIButton(type: .system)
//
//            cameraTapped.setImage(#imageLiteral(resourceName: "PhotoCamera").withRenderingMode(.alwaysOriginal), for: .normal)
//
//            cameraTapped.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//
//            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cameraTapped)
//
//            cameraTapped.addTarget(self, action: #selector(takePhotoAction), for: .touchUpInside)
//
//        } else {
//            navigationItem.rightBarButtonItem = nil
//        }
        
        // Remove previous viewController
        selectedViewController.willMove(toParentViewController: nil)
        selectedViewController.view.removeFromSuperview()
        selectedViewController.removeFromParentViewController()
        
        // Add new viewController
        addChildViewController(newViewController)
        self.containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.bounds
        newViewController.didMove(toParentViewController: self)
        
        // Set up current viewController == selectedViewController
        self.selectedViewController = newViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ContainerViewSegue" {
            
            let navigationController = self.navigationController as! StoreDetailNavigationController
            
            if let selectedMarkerId = navigationController.selectedMarkerId {
                
                StoreInfoViewController = segue.destination as! StoreInfoViewController
                let storeInfoVC = StoreInfoViewController
                storeInfoVC?.addressValue = selectedMarkerId.address
                storeInfoVC?.phoneValue = selectedMarkerId.phone
                storeInfoVC?.scorePeopleValue = selectedMarkerId.scoredPeople
                storeInfoVC?.longitudeValue = selectedMarkerId.longitude
                storeInfoVC?.latitudeValue = selectedMarkerId.latitude
                storeInfoVC?.storeScoreAverageValue = selectedMarkerId.storeScoreAverage
                storeInfoVC?.nameValue = selectedMarkerId.name
            }
        }
    }
}

//extension StoreDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
//    {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        {
//            ScoreViewController.scoreImageView.image = pickedImage
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//}


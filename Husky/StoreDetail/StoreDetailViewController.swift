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
        
//        let button = UIButton(type: .custom)
//        button.setImage( #imageLiteral(resourceName: "Back"), for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
//        let barButton = UIBarButtonItem.init(customView: button)
//        self.navigationItem.leftBarButtonItem = barButton
//
        let navigationController = self.navigationController as! StoreDetailNavigationController
        
        self.selectedMarkerId = navigationController.selectedMarkerId
        
        // SetUp navigationBar
        setUpNavigationBar()
        
        // SetUp default page
        selectedViewController = StoreInfoViewController
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let contentSize = self.textView.sizeThatFits(self.textView.bounds.size)
//        var frame = self.textView.frame
//        frame.size.height = contentSize.height
//        self.textView.frame = frame
//
//        aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.textView, attribute: .height, relatedBy: .equal, toItem: self.textView, attribute: .width, multiplier: textView.bounds.height/textView.bounds.width, constant: 1)
//        self.textView.addConstraint(aspectRatioTextViewConstraint)!
//    }
    
    @IBAction func backToMapPageTapped(_ sender: Any) {
//
//        let button = UIButton(type: .custom)
//        button.setImage( #imageLiteral(resourceName: "Back"), for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
//        let barButton = UIBarButtonItem.init(customView: button)
//        self.navigationItem.leftBarButtonItem = barButton
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpNavigationBar() {
        
        //navigationItem.title = selectedMarkerId?.name
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Papyrus", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let textView = UITextView()
        textView.text = selectedMarkerId?.name
        textView.font = UIFont(name: "NotoSansCJKtc-Regular", size: 18)
        textView.textAlignment = .center
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
    
        textView.sizeToFit()
        navigationItem.titleView = textView
        
    }
    
    func changePage(to newViewController: UIViewController) {
        
        if newViewController is ScoreViewController {
            
            let cameraTapped = UIButton(type: .system)
            cameraTapped.setImage(#imageLiteral(resourceName: "PhotoCamera").withRenderingMode(.alwaysOriginal), for: .normal)
            cameraTapped.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cameraTapped)
            cameraTapped.addTarget(self, action: #selector(takePhotoAction), for: .touchUpInside)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        

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
    
    @objc func takePhotoAction() {
        let pickercontroller = UIImagePickerController()
        pickercontroller.delegate = self
        pickercontroller.allowsEditing = true
        
        let alertController = UIAlertController(
            title: "Add a Picture",
            message: "Choose From",
            preferredStyle: .actionSheet
        )
        let photosLibraryAction = UIAlertAction(
        title: "Photo Library",
        style: .default
        ) { (action) in
            pickercontroller.sourceType = .photoLibrary
            self.present(
                pickercontroller,
                animated: true,
                completion: nil
            )
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: nil
        )
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            let cameraAction = UIAlertAction(
                title: "Camera",
                style: .default,
                handler: { (action) in
                pickercontroller.sourceType = .camera
                self.present(
                    pickercontroller,
                    animated: true,
                    completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photosLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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

extension StoreDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            ScoreViewController.scoreImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

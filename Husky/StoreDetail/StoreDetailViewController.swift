//
//  StoreDetailViewController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/15.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        selectedViewController = StoreInfoViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        selectedViewController = StoreInfoViewController
    }
    
    func setUpNavigationBar() {
        
        navigationItem.title = selectedMarkerId?.name
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func changePage(to newViewController: UIViewController) {

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

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
    
    @IBOutlet weak var storeInfoPageTapped: UIButton!
    
    @IBOutlet weak var scorePageTapped: UIButton!
    
    @IBOutlet weak var commentsPageTapped: UIButton!
    

    @IBAction func showStoreInfoPageTapped(_ sender: Any) {
         changePage(to: StoreInfoViewController)
    }
    
    @IBAction func showScorePageTapped(_ sender: Any) {
         changePage(to: ScoreViewController)
    }
    
    @IBAction func showCommentsPageTapped(_ sender: Any) {
        changePage(to: CommentsTableViewController)
    }
    
    
    
    @IBOutlet weak var containerView: UIView!
    
    var StoreInfoViewController: StoreInfoViewController!
    
    var selectedViewController: UIViewController!
    
    lazy var CommentsTableViewController: CommentsTableViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "CommentsTableViewController") as! CommentsTableViewController
    }()
    
    lazy var ScoreViewController: ScoreViewController = {
        self.storyboard!.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerViewSegue" {
            StoreInfoViewController = segue.destination as! StoreInfoViewController
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

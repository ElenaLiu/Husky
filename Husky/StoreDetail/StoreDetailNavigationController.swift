//
//  StoreDetailNavigationController.swift
//  Husky
//
//  Created by 劉芳瑜 on 2017/12/19.
//  Copyright © 2017年 Fang-Yu. Liu. All rights reserved.
//

import UIKit

class StoreDetailNavigationController: UINavigationController {

    var selectedMarkerId: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedMarkerId)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

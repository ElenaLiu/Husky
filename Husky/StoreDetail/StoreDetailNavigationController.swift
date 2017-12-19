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

        print("我是navigation\(selectedMarkerId)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

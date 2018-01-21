//
//  LoadingFunction.swift
//  Husky
//
//  Created by 劉芳瑜 on 2018/1/1.
//  Copyright © 2018年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import SVProgressHUD

var isLoading = false

func startLoading(status: String) { //status loading title name
    
    if isLoading == true {
        
        return
    }
    
    isLoading = true
    
    SVProgressHUD.show(withStatus: status)
    
    UIApplication.shared.beginIgnoringInteractionEvents()
}

func endLoading() {
    
    if isLoading == false {
        
        return
    }
    
    isLoading = false
    
    SVProgressHUD.dismiss()
    
    UIApplication.shared.endIgnoringInteractionEvents()
}



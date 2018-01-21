//
//  checkConnection.swift
//  Husky
//
//  Created by 劉芳瑜 on 2018/1/21.
//  Copyright © 2018年 Fang-Yu. Liu. All rights reserved.
//

import Foundation
import SCLAlertView

var reachability = Reachability(hostName: "www.apple.com")

func checkInternetFunction() -> Bool {
    if reachability?.currentReachabilityStatus().rawValue == 0 {
        
        endLoading()
        
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
        
        alertView.showEdit(
            NSLocalizedString("Oops!", comment: ""),
            subTitle: NSLocalizedString("No internet connected! Please try again.", comment: "")
        )
        
        print("no internet connected.")
        return false
    }else {
        
        print("internet connected successfully.")
        return true
    }
}


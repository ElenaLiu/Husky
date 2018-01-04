//
//  GradientFunction.swift
//  Husky
//
//  Created by 劉芳瑜 on 2018/1/4.
//  Copyright © 2018年 Fang-Yu. Liu. All rights reserved.


import Foundation
import UIKit

extension UIView {
    
    func setGradient(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.2, 0.9]
        gradientLayer.startPoint = CGPoint(x: 1.0, y:1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
}





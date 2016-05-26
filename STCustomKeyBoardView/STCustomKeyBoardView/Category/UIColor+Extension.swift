//
//  UIColor+Extension.swift
//  STCustomKeyBoardView
//
//  Created by 苏统世 on 16/5/24.
//  Copyright © 2016年 SuTon. All rights reserved.
//

import UIKit

// MARK: - ====================================
// MARK: UIColor 分类：随机颜色
// MARK: ====================================
extension UIColor {
    /// 随机颜色
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256)) / 255.0
        let g = CGFloat(arc4random_uniform(256)) / 255.0
        let b = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: r , green: g, blue: b, alpha: 1)
    }
}


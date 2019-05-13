//
//  Common.swift
//  PlayerPro
//
//  Created by William on 2019/4/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

let kFont  = #"PingFangSC-Regular"#
let kBFont = #"PingFangSC-Semibold"#

let kColor = UIColor.black
let kTintColor = UIColor.yellow

// 屏幕
let SCREEN_WIDTH  = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

func safeAreaTop() -> CGFloat {
    if #available(iOS 11.0, *) {
        // iOS 12.0 以后的非刘海手机top为 20.0
        if (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom == 0.0 {
            return 20.0
        }
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.top ?? 20.0
    }
    return 20.0
}

func safeAreaBottom() -> CGFloat {
    if #available(iOS 11.0, *) {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom ?? 0.0
    }
    return 0.0
}

func navigationHeight() -> CGFloat {
    return 44 + safeAreaTop()
}

func toolBarHeight() -> CGFloat {
    return 49 + safeAreaBottom()
}

func hasSafeArea() -> Bool {
    if #available(iOS 11.0, *) {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.safeAreaInsets.bottom ?? CGFloat(0) > CGFloat(0)
    } else {
        return false
    }
}

func font(fontName: String, fontSize: CGFloat) -> UIFont {
    return UIFont(name: fontName, size: fontSize)!
}

let kChangeRootViewController = "kChangeRootViewController"

func randColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(255))/255.0,
                   green: CGFloat(arc4random_uniform(255))/255.0,
                   blue: CGFloat(arc4random_uniform(255))/255.0,
                   alpha: 1.0)
}

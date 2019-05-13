//
//  UISlider+WJExtension.swift
//  PlayerPro
//
//  Created by William on 2019/4/24.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

extension UISlider {
    convenience init(_ image: String, _ target: Any?, _ action: Selector?) {
        self.init(UIImage.tintImage(image), target, action)
    }
    
    convenience init(_ image: UIImage?, _ target: Any?, _ action: Selector?) {
        self.init()
        setThumbImage(image, for: .normal) //minimumTrackTintColor
        minimumTrackTintColor = kTintColor
        if let target = target, let action = action {
            addTarget(target, action: action, for: .valueChanged)
        }
    }
}

//
//  UIButton+WJExtension.swift
//  PlayerPro
//
//  Created by William on 2019/4/19.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

extension UIButton {
    
    // TODO: 遍历构造函数
    convenience init(text: String, textColor: UIColor, fontSize: CGFloat) {
        self.init();
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont(name: kFont, size: fontSize)
    }
    
    convenience init(text: String? = "", textColor: UIColor? = nil, fontSize: CGFloat? = 14, target: Any?, action: Selector?) {
        self.init();
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont(name: kFont, size: fontSize ?? 14)
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    // MARK: set normal image
    convenience init(_ imageName: String, _ target: Any?, _ action: Selector?) {
        self.init(UIImage(named: imageName), target, action)
    }
    
    convenience init(_ image: UIImage?, _ target: Any?, _ action: Selector?) {
        self.init()
        setImage(image, for: .normal)
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    // MARK: set normal and select image
    convenience init(_ normalImageName: String,
                     _ selectImageName: String,
                     _ target: Any?,
                     _ action: Selector?) {
        self.init(UIImage(named: normalImageName),
                  UIImage(named: selectImageName),
                  target, action)
    }
    
    convenience init(_ normalImage: UIImage?,
                     _ selectImage: UIImage?,
                     _ target: Any?,
                     _ action: Selector?) {
        self.init()
        setImage(normalImage, for: .normal)
        setImage(selectImage, for: .selected)
        if let target = target, let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
//    convenience init(_ normalImage: String, _ selectImage: String, _ themeColor: Bool? = false, _ target: Any?, _ action: Selector?) {
//        self.init();
//        setImage(UIImage(named: normalImage), for: .normal)
//        setImage(UIImage(named: selectImage), for: .selected)
//        if let target = target, let action = action {
//            addTarget(target, action: action, for: .touchUpInside)
//        }
//    }
}


//
//  UILabel+WJExtension.swift
//  PlayerPro
//
//  Created by William on 2019/4/22.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(_ text: String,
                     _ textColor: UIColor? = kColor,
                     _ fontName: String? = kFont,
                     _ fontSize: CGFloat? = 14,
                     _ textAlignment: NSTextAlignment? = .center) {
        self.init()
        self.text = text;
        self.textColor = textColor
        self.font = UIFont(name: fontName!, size: fontSize!)
        self.textAlignment = textAlignment!
    }
}

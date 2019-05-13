//
//  UIView+WJExtension.swift
//  PlayerPro
//
//  Created by William on 2019/4/22.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

extension UIView {
    
    open func wj_removeAllSubviews() {
        let subviews = self.subviews;
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

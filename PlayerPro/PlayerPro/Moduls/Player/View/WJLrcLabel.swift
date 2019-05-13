//
//  WJLrcLabel.swift
//  PlayerPro
//
//  Created by William on 2019/4/24.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

class WJLrcLabel: UILabel {
    
    var line: WJLrcLineModel?

    var isHighlight: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var highlightWidth: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isHighlight {
            /// 颜色填充
            kTintColor.setFill()
            UIRectFillUsingBlendMode(CGRect(x: 0.0,
                                            y: 0.0,
                                            width: highlightWidth,
                                            height: self.frame.size.height),
                                     .sourceIn)
        }
    }

}

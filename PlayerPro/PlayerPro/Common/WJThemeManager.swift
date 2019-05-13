//
//  WJThemeManager.swift
//  PlayerPro
//
//  Created by William on 2019/4/25.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

class WJThemeManager: NSObject {
    
    let mainColor: UIColor? = nil
    
    open func imageName(_ name: String) -> UIImage? {
        return UIImage(named: name)
    }
    
}

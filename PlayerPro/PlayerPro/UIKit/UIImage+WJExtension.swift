//
//  UIImage+WJExtension.swift
//  PlayerPro
//
//  Created by William on 2019/4/25.
//  Copyright © 2019 William. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: default tint color
    open class func tintImage(_ named: String) -> UIImage? {
        return tintImage(named, kTintColor)
    }
    
    open class func gradientTintImage(_ named: String) -> UIImage? {
        return gradientTintImage(named, kTintColor)
    }
    
    // MARK:
    open class func tintImage(_ named: String, _ tintColor: UIColor) -> UIImage? {
        let image = UIImage(named: named)
        return image?.tintedImage(tintColor, .destinationIn)
    }
    
    open class func gradientTintImage(_ named: String, _ tintColor: UIColor) -> UIImage? {
        let image = UIImage(named: named)
        return image?.tintedImage(tintColor, .overlay)
    }
    
    // MARK: instance method
    open func tintImage(_ tintColor: UIColor) -> UIImage? {
        return self.tintedImage(tintColor, .destinationIn)
    }
    
    open func gradientTintImage(_ tintColor: UIColor) -> UIImage? {
        return self.tintedImage(tintColor, .overlay)
    }
    
    /**
     *  图层混合模式
     *  r g b a
     *  S -> 代表图片, D -> tintColor
     *  R = D*Sa
     *  R 结果色
     *  D 目标色
     *  S 源色
     *  kCGBlendModeSourceIn R = S*Da
     *  kCGBlendModeSourceOut R = S*(1 - Da)
     *  kCGBlendModeDestinationOut R = D*(1 - Sa)
     */
    private func tintedImage(_ tintColor: UIColor, _ blendMode: CGBlendMode) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}

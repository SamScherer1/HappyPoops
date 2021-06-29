//
//  UIColor+EffectiveColors.swift
//  HappyPoops
//
//  Created by Samuel Scherer on 6/28/21.
//

import Foundation

extension UIColor {
    class func halfTransparentDarkColor() -> UIColor {
        return UIColor(white: 0.25, alpha: 0.5)
    }
    
    class func mostlyOpaqueDarkColor() -> UIColor {
        return UIColor(white: 0.25, alpha: 0.85)
    }
    
    class func mostlyClearWhiteColor() -> UIColor {
        return UIColor(white: 1.0, alpha: 0.25)
    }
    
    class func mostlyOpaqueWhiteColor() -> UIColor {
        return UIColor(white: 1.0, alpha: 0.85)
    }
}

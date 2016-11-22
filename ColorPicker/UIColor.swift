//
//  UIColor.swift
//  ColorPicker
//
//  Created by Martin Beran on 22.11.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

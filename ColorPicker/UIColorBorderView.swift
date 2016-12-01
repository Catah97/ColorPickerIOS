//
//  ColorModeUIView.swift
//  ColorPicker
//
//  Created by Martin Beran on 29.11.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

@IBDesignable
class UIColorBorderView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

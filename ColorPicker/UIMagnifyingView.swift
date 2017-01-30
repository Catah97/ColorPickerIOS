//
//  UIMagnifireView.swift
//  ColorPicker
//
//  Created by Martin Beran on 30.01.17.
//  Copyright © 2017 Martin Beran. All rights reserved.
//

import UIKit

@IBDesignable
class UIMagnifireView: UIScrollView {
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

//
//  UIPhotoPickerScrollView.swift
//  ColorPicker
//
//  Created by Martin Beran on 09.02.17.
//  Copyright © 2017 Martin Beran. All rights reserved.
//

import UIKit

@IBDesignable
class UIPhotoPickerImageView : UIImageView{
    
    var touchedPoint : CGPoint!
    @IBInspectable var pointColor: UIColor = UIColor.blue
    
    override func draw(_ rect: CGRect) {
        print("draw")
        if let touchedPoint = self.touchedPoint {
            let path = UIBezierPath()
            path.lineWidth = 2.0
            path.addArc(withCenter: touchedPoint, radius: 20.0, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            pointColor.setStroke()
            path.stroke()
        }
    }
}

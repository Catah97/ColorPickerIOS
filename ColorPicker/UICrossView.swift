//
//  UICrossView.swift
//  ColorPicker
//
//  Created by Martin Beran on 31.01.17.
//  Copyright © 2017 Martin Beran. All rights reserved.
//

import UIKit

@IBDesignable
class UICrossView: UIView {
    
    @IBInspectable var plusHeight: CGFloat = 1
    @IBInspectable var crossColor: UIColor = UIColor.red
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = plusHeight
        drawVertical(path: path)
        drawHorizontal(path: path)
        crossColor.setStroke()
        path.stroke()
    }
    
    private func drawVertical(path : UIBezierPath){
        path.move(to: CGPoint(
            x:0,
            y:bounds.height/2))
        
        path.addLine(to: CGPoint(
            x:bounds.width,
            y:bounds.height/2))
        
    }
    
    private func drawHorizontal(path : UIBezierPath){
        path.move(to: CGPoint(
            x:bounds.width/2,
            y:0))
        
        path.addLine(to: CGPoint(
            x:bounds.width/2,
            y:bounds.height))
    }
    
    
}

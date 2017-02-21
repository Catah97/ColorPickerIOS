//
//  UIPhotoPickerScrollVIew.swift
//  ColorPicker
//
//  Created by Martin Beran on 16.02.17.
//  Copyright © 2017 Martin Beran. All rights reserved.
//

import UIKit


public protocol UIPhotoPickerScrollViewDelegate {
    func onColorChange(_ touches: Set<UITouch>,touchState : UIGestureRecognizerState,  forceTouch : Bool)
}

class UIPhotoPickerScrollView : UIScrollView {
    
    var forceTouch = false
    
    public var photoPickerScrollViewDelegate : UIPhotoPickerScrollViewDelegate!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            isScrollEnabled = false
            let maxForce = touch?.maximumPossibleForce
            let force = touch?.force
            if maxForce == force && maxForce != 0 {
                self.forceTouch = true
            }
        }

        self.photoPickerScrollViewDelegate.onColorChange(touches, touchState: .began, forceTouch: self.forceTouch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        photoPickerScrollViewDelegate.onColorChange(touches, touchState: .changed, forceTouch: self.forceTouch)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchEnded(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchEnded(touches, with: event)
    }
    
    func touchEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        photoPickerScrollViewDelegate.onColorChange(touches, touchState: .ended, forceTouch: self.forceTouch)
        isScrollEnabled = true
        self.forceTouch = false
    }
}

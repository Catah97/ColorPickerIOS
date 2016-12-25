//
//  MyColor.swift
//  ColorPicker
//
//  Created by Martin Beran on 20.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

class MyColor{
    
    public var color : UIColor
    public var colorName : String
    public var colorMode : ColorMode
    
    
    init(color : UIColor, colorName : String, colorMode : ColorMode){
        self.color = color
        self.colorName = colorName
        self.colorMode = colorMode
    }
    
}

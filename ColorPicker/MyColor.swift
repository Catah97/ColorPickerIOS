//
//  MyColor.swift
//  ColorPicker
//
//  Created by Martin Beran on 20.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

public class MyColor{
    
    public var color : UIColor
    public var colorName : String
    public var colorMode : ColorMode
    public var ID : Int
    
    init(color : UIColor, colorName : String, colorMode : ColorMode, ID : Int){
        self.color = color
        self.colorName = colorName
        self.colorMode = colorMode
        self.ID = ID
    }
    
}

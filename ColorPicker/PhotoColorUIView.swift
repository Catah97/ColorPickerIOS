//
//  ColorUI.swift
//  ColorPicker
//
//  Created by Martin Beran on 22.10.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class PhotoColorUIView: UIView {
    
    @IBOutlet weak var RGBmodel: UIView!

    @IBOutlet weak var rgbR: UILabel!
    @IBOutlet weak var rgbG: UILabel!
    @IBOutlet weak var rgbB: UILabel!

    @IBOutlet weak var HEXmodel: UIView!
    
    @IBOutlet weak var hexR: UILabel!
    @IBOutlet weak var hexG: UILabel!
    @IBOutlet weak var hexB: UILabel!

    @IBOutlet weak var CMYKmodel: UIView!
    
    @IBOutlet weak var cmykC: UILabel!
    @IBOutlet weak var cmykM: UILabel!
    @IBOutlet weak var cmykY: UILabel!
    @IBOutlet weak var cmykK: UILabel!
    
    @IBOutlet weak var HSVmodel: UIView!
    
    @IBOutlet weak var hsvH: UILabel!
    @IBOutlet weak var hsvS: UILabel!
    @IBOutlet weak var hsvV: UILabel!

    
    public func onColorChange(color: UIColor){
        onColorChangeWithoutChangeBackGround(color: color)
        self.backgroundColor = color
    }
    
    public func onColorChangeWithoutChangeBackGround(color: UIColor){
        let colorMode = self.colorMode()
        showRightView(colorMode: colorMode)
        let myColorComponents = color.components
        let alpha = myColorComponents.alpha * 255
        let red = myColorComponents.red * 255
        let green = myColorComponents.green * 255
        let blue = myColorComponents.blue * 255
        let alphaRounded = Int(round(alpha))
        let redRounded = Int(round(red))
        let greenRounded = Int(round(green))
        let blueRounded = Int(round(blue))
        setRGB(alpha: alphaRounded, red: redRounded, green: greenRounded, blue: blueRounded)
        setHEX(alpha: alphaRounded, red: redRounded, green: greenRounded, blue: blueRounded)
        setCMYK(alpha: alphaRounded, red: redRounded, green: greenRounded, blue: blueRounded)
        setHSV(alpha: alphaRounded, red: redRounded, green: greenRounded, blue: blueRounded)
    }
    
    private func colorMode() -> ColorMode{
        let mode = SettingControler.colorMode()
        let colorMode = ColorMode.colorMode(value: mode)
        return colorMode
    }
    
    private func showRightView(colorMode: ColorMode){
        RGBmodel.isHidden = true
        HEXmodel.isHidden = true
        CMYKmodel.isHidden = true
        HSVmodel.isHidden = true
        print(colorMode)
        switch colorMode {
        case .RGB:
            RGBmodel.isHidden = false
        case .HEX:
            HEXmodel.isHidden = false
        case .CMYK:
            CMYKmodel.isHidden = false
        case .HSV:
            HSVmodel.isHidden = false
        }
    }
    
    private func setRGB(alpha: Int, red: Int, green: Int, blue:Int) {
        let rgb = ColorMode.rgb(alpha: alpha, red: red, green: green, blue: blue)
        self.rgbR.text = rgb.red
        self.rgbG.text = rgb.green
        self.rgbB.text = rgb.blue
    }
    
    private func setHEX(alpha: Int, red: Int, green: Int, blue:Int){
        let hex = ColorMode.hex(alpha: alpha, red: red, green: green, blue: blue)
        self.hexR.text = hex.red
        self.hexG.text = hex.green
        self.hexB.text = hex.blue
    
    }
    
    private func setCMYK(alpha: Int, red: Int, green: Int, blue:Int) {
        let cmyk = ColorMode.cmyk(alpha: alpha, red: red, green: green, blue: blue)
        self.cmykC.text = cmyk.c
        self.cmykM.text = cmyk.m
        self.cmykY.text = cmyk.y
        self.cmykK.text = cmyk.k
    }

    private func setHSV(alpha: Int, red: Int, green: Int, blue:Int) {
        let hsv = ColorMode.hsv(alpha: alpha, red: red, green: green, blue: blue)
        self.hsvH.text = hsv.h
        self.hsvS.text = hsv.s
        self.hsvV.text = hsv.v
    }

}

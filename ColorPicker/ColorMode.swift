//
//  ColorMode.swift
//  ColorPicker
//
//  Created by Martin Beran on 23.10.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

enum ColorMode{
    case RGB, HEX, CMYK, HSV
    
    public static func colorMode(value : Int) -> ColorMode {
        var result : ColorMode
        switch value {
        case 0:
            result = ColorMode.RGB
        case 1:
            result = ColorMode.HEX
        case 2:
            result = ColorMode.CMYK
        default:
            result = ColorMode.HSV
        }
        return result
    }
    
    public static var colorModes = ["RGB", "HEX", "CMYK", "HSV"]
    
    public static func createColorValues(color : UIColor, colorMode : ColorMode) -> String {
        switch colorMode {
        case .RGB:
            return rgb(color: color).result
        case .HEX:
            return hex(color: color).result
        case .CMYK:
            return cmyk(color: color).result
        default:
            return hsv(color: color).result
        }
    }
    
    public static func components(color: UIColor) -> (alpha: Int, red: Int, green: Int, blue: Int) {
        let myColorComponents = color.components
        let alpha = myColorComponents.alpha * 255
        let red = myColorComponents.red * 255
        let green = myColorComponents.green * 255
        let blue = myColorComponents.blue * 255
        let alphaRounded = Int(round(alpha))
        let redRounded = Int(round(red))
        let greenRounded = Int(round(green))
        let blueRounded = Int(round(blue))
        return (alphaRounded, redRounded, greenRounded, blueRounded)
        }
    
    public static func rgb(color: UIColor) -> (result: String, alpha: String, red: String, green: String, blue: String) {
        let components = self.components(color: color)
        return rgb(alpha: components.alpha, red: components.red, green: components.green, blue: components.blue)
    }
    
    public static func rgb(alpha: Int, red: Int, green: Int, blue: Int) -> (result: String, alpha: String, red: String, green: String, blue: String) {
        let rgbA = String(describing: alpha)
        let rgbR = String(describing: red)
        let rgbG = String(describing: green)
        let rgbB = String(describing: blue)
        let result = "R: " + String(describing: red) + " G: " + String(describing: green) + " B: " + String(describing: blue)
        return (result, rgbA, rgbR, rgbG, rgbB)
    }
    
    public static func hex(color: UIColor) -> (result: String, alpha: String, red: String, green: String, blue: String) {
        let components = self.components(color: color)
        return hex(alpha: components.alpha, red: components.red, green: components.green, blue: components.blue)
    }
    
    public static func hex(alpha: Int, red: Int, green: Int, blue: Int) -> (result: String, alpha: String, red: String, green: String, blue: String) {
        let hexAlpha = String(alpha, radix: 16, uppercase: true)
        var hexR = String(red, radix: 16, uppercase: true)
        hexR = addZero(val: hexR)
        var hexG = String(green, radix: 16, uppercase: true)
        hexG = addZero(val: hexG)
        var hexB = String(blue, radix: 16, uppercase: true)
        hexB = addZero(val: hexB)
        let result = "#" + hexR + hexG + hexB
        return (result, hexAlpha, hexR, hexG, hexB)
    }
    private static func addZero(val : String) -> String{
        if val.characters.count == 1 {
            return "0" + val
        }
        return val;
    }
    
    public static func cmyk(color: UIColor) -> (result: String, c: String, m: String, y: String, k: String) {
        let components = self.components(color: color)
        return cmyk(alpha: components.alpha, red: components.red, green: components.green, blue: components.blue)
    }
    
    public static func cmyk(alpha: Int, red: Int, green: Int, blue: Int) -> (result: String, c: String, m: String, y: String, k: String) {
        var c = 1 - Double(red)/255.0
        var m = 1 - Double(green)/255.0
        var y = 1 - Double(blue)/255.0
        
        let minCMY = min(c, min(m, y))
        c = (c - minCMY) / (1 / minCMY)
        m = (m - minCMY) / (1 / minCMY)
        y = (y - minCMY) / (1 / minCMY)
        var k = minCMY
        
        //round
        c = roundColorMode(value: c)
        m = roundColorMode(value: m)
        y = roundColorMode(value: y)
        k = roundColorMode(value: k)
        let cmykC = String(describing: c)
        let cmykM = String(describing: m)
        let cmyky = String(describing: y)
        let cmykK = String(describing: k)
        let result = "C: " + cmykC + " M: " + cmykM
            + " Y: " + cmyky + " K: " + cmykK
        return (result, cmykC, cmykM, cmyky, cmykK)
    }
    
    public static func hsv(color: UIColor) -> (result: String, h: String, s: String, v: String) {
        let components = self.components(color: color)
        return hsv(alpha: components.alpha, red: components.red, green: components.green, blue: components.blue)
    }
    
    public static func hsv(alpha: Int, red: Int, green: Int, blue: Int) -> (result: String, h: String, s: String, v: String) {
        print("Color a\(alpha) r\(red) g \(green) b\(blue) ")
        let r = Double(red)/255.0
        let g = Double(green)/255.0
        let b = Double(blue)/255.0
        
        let shvMax = max(r, max(g, b))
        let shvMin = min(r, min(g, b))
        let diff = shvMax-shvMin
        
        /**h*/
        var h = 0.0;
        if (shvMax == shvMin){
            h = 0
        }
        else if (shvMax == r && g >= b){
            h = Double((60 * ((g-b)/diff)+0))
        }
        else if (shvMax == r && g<b){
            h = Double(60 * ((g-b)/diff)+360)
        }
        else if (shvMax == g){
            h = Double(60 * ((b-r)/diff)+120)
        }
        else if (shvMax == b){
            h = Double(60 * ((r-g)/diff)+240)
        }
        
        var s = 0.0
        if  shvMax != 0{
            s = 1 - diff
        }
        
        var v = shvMax
        //round
        h = roundColorMode(value: h)
        s = roundColorMode(value: s)
        s = s * 100
        v = roundColorMode(value: v)
        v = v * 100
        let hsvH = String(describing: Int(h)) + "°"
        let hsvS = String(describing: Int(s)) + "%"
        let hsvV = String(describing: Int(v)) + "%"

        let result = "H: " + hsvH + " M: " + hsvS
            + " Y: " + hsvV
        return (result, hsvH, hsvS, hsvV)
    }
    
    private static func roundColorMode(value: Double) -> Double{
        var result = value * 1000;
        result = round(result)
        result = result / 1000
        return result;
    }

}


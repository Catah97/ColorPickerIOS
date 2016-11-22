//
//  SettingControler.swift
//  ColorPicker
//
//  Created by Martin Beran on 12.10.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class SettingControler: UIViewController {
    
    open static let color_mode_key = "colorModeKey"
    let saveValue = 0;
    
    @IBOutlet weak var rgb: DLRadioButton!
    @IBOutlet weak var hex: DLRadioButton!
    @IBOutlet weak var cmyk: DLRadioButton!
    @IBOutlet weak var hsv: DLRadioButton!
    
    @IBAction func valueChange(_ sender: DLRadioButton) {
        switch sender {
        case rgb:
            SettingControler.colorMode(value: 0)
        case hex:
            SettingControler.colorMode(value: 1)
        case cmyk:
            SettingControler.colorMode(value: 2)
        case hsv:
            SettingControler.colorMode(value: 3)
        default:
            print("value change unknown sender")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Nastavení"
        setCheckBoxValue(value: SettingControler.colorMode())

    }
    
    open static func colorMode() -> Int{
        let preferences = UserDefaults.standard
        return preferences.integer(forKey: SettingControler.color_mode_key)
    }
    
    open static func colorMode(value: Int){
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: SettingControler.color_mode_key)
    }
    
    func setCheckBoxValue(value: Int){
        self.rgb.isSelected = false
        self.hex.isSelected = false
        self.cmyk.isSelected = false
        let colorMode = ColorMode.colorMode(value: value)
        switch colorMode {
        case .RGB:
            self.rgb.isSelected = true
        case .HEX:
            self.hex.isSelected = true
        case .CMYK:
            self.cmyk.isSelected = true
        case .HSV:
            self.hsv.isSelected = true
        }
    }
}

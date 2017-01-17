//
//  PhotoDialgVIew.swift
//  ColorPicker
//
//  Created by Martin Beran on 30.10.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

public protocol PhotoDialogDelegate {
    func onOkClick(colorName : String, color : UIColor, mainColorMode : ColorMode)
}

@IBDesignable class PhotoDialogUIView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, CustomIOSAlertViewDelegate {
    
    var view : UIView!
    var firstSettingValue : Int!
    var color : UIColor!
    
    @IBOutlet weak var colorModePicker: UIPickerView!
    
    @IBOutlet weak var colorName: UITextField!
    @IBOutlet weak var colorPrevie: UIView!
    
    @IBOutlet weak var photoColor: PhotoColorUIView!
    
    var delegate : PhotoDialogDelegate!

    
    init(frame: CGRect, color: UIColor, delegate: PhotoDialogDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        setup()
        firstSettingValue = SettingControler.colorMode()
        self.color = color
        colorModePicker.selectRow(firstSettingValue, inComponent: 0, animated: false)
        setColor(color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setup()
    }
    
    
    private func setColor(color: UIColor){
        photoColor.onColorChangeWithoutChangeBackGround(color: color)
        colorPrevie.layer.borderWidth = 1
        colorPrevie.layer.borderColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        colorPrevie.backgroundColor = color
    }
    
    private func setup(){
        view = self.loadViewFromXib()
        view.frame = bounds
        addSubview(view)
        setUIColorModePicker()
    }
    
    private func setUIColorModePicker(){
        colorModePicker.delegate = self
        colorModePicker.dataSource = self
    }

    
    private func loadViewFromXib() -> UIView{
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "PhotoDialogUIView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = ColorMode.colorModes[row]
        
        return pickerLabel!;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ColorMode.colorModes.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SettingControler.colorMode(value: row)
        setColor(color: color)
        print("Selected: " + String(row))
    }
    
    func onButtonClick(_ alertView: Any!, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            onOkClick()
        }
        SettingControler.colorMode(value: firstSettingValue)
        let dialog : CustomIOSAlertView = alertView as! CustomIOSAlertView
        dialog.close()
    }
    
    func onOkClick() {
        let colorName = self.colorNameCreator()
        let color = colorPrevie.backgroundColor
        let colorMode = ColorMode.colorMode(value: SettingControler.colorMode())
        self.delegate.onOkClick(colorName: colorName, color: color!, mainColorMode: colorMode)
        
    }
    
    func colorNameCreator() -> String {
        var result = self.colorName.text
        if result?.characters.count == 0 {
            result = "My color";
        }
        return result!
    }
    
}

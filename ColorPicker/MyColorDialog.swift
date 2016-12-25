//
//  MyColorDialog.swift
//  ColorPicker
//
//  Created by Martin Beran on 20.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class MyColorDialog : UIView{

    @IBOutlet weak var colorName : UILabel!
    @IBOutlet weak var colorPreview: UIView!
    
    @IBAction func onEndClick() {
        parrent.close()
    }
    
    var parrent : CustomIOSAlertView!
    var view : UIView!
    var firstSettingValue : Int!
    var myColor : MyColor!
    
    init(frame: CGRect, myColor: MyColor, parrent : CustomIOSAlertView) {
        super.init(frame: frame)
        firstSettingValue = SettingControler.colorMode()
        self.myColor = myColor
        self.parrent = parrent;
        setup()
        setItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setup()
    }
    
    private func setup(){
        view = self.loadViewFromXib()
        view.frame = bounds
        addSubview(view)
    }
    
    private func setItems(){
        colorPreview.backgroundColor = myColor.color
        colorName.text = myColor.colorName
    }
    
    private func loadViewFromXib() -> UIView{
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "MyColorDialog", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    open static func showUiAlert(myColor: MyColor, controler : UIViewController) {
        let customAlerView = CustomIOSAlertView()
        let myColorView = myColorDialog(myColor: myColor, parrent: customAlerView!)
        customAlerView?.containerView = myColorView as UIView
        customAlerView?.useMotionEffects = true
        customAlerView?.show()
    }
    
    static func myColorDialog(myColor: MyColor, parrent : CustomIOSAlertView) -> MyColorDialog{
        let frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        let pickView = MyColorDialog(frame: frame, myColor: myColor, parrent : parrent)
        return pickView
    }
}

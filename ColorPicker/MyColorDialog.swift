//
//  MyColorDialog.swift
//  ColorPicker
//
//  Created by Martin Beran on 20.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

public protocol MyColorDialogDelegate{
    func tableView(selectedColorMode : ColorMode, myColor : MyColor)
}

class MyColorDialog : UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var colorName : UILabel!
    @IBOutlet weak var colorPreview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var endButton: UIButton!

    
    private var modes = Array<ColorMode>(arrayLiteral: ColorMode.RGB , ColorMode.HEX, ColorMode.CMYK, ColorMode.HSV)
    
    @IBAction func onEndClick() {
        parrent.close()
    }
    
    var parrent : CustomIOSAlertView!
    var view : UIView!
    var firstSettingValue : Int!
    var myColor : MyColor!
    var delegate : MyColorDialogDelegate!

    
    init(frame: CGRect, myColor: MyColor, parrent : CustomIOSAlertView, delegate : MyColorDialogDelegate) {
        super.init(frame: frame)
        self.myColor = myColor
        self.parrent = parrent;
        self.delegate = delegate
        setMainColor()
        setup()
        setItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setup()
    }

    private func setMainColor(){
        let mainColorMode =  myColor.colorMode
        modes.insert(mainColorMode, at: 0)
        for position in 1...modes.count{
            let mode = modes[position]
            if mode == mainColorMode {
                modes.remove(at: position)
                break
            }
        }
    }
    
    private func setup(){
        view = self.loadViewFromXib()
        view.frame = bounds
        addSubview(view)
    }
    
    private func setItems(){
        colorPreview.layer.borderWidth = 1
        colorPreview.layer.borderColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        colorPreview.backgroundColor = myColor.color
        colorName.text = myColor.colorName
    }
    
    private func loadViewFromXib() -> UIView{
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "MyColorDialog", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        var tableCell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        if  (tableCell == nil){
            tableCell = UITableViewCell.init(style: .default, reuseIdentifier: "MyCell")
        }
        if position == 0 {
            tableCell?.selectionStyle = UITableViewCellSelectionStyle.none
            tableCell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        }
        else{
            tableCell?.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        }
        tableCell?.textLabel?.text = ColorMode.createColorValues(color: myColor.color, colorMode: modes[position])
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let position = indexPath.row
        if position > 0 {
            let colorMode = modes[position]
            delegate.tableView(selectedColorMode: colorMode, myColor: self.myColor)
            parrent.close()
        }
    }
    
    open static func showUiAlert(myColor: MyColor, controler : UIViewController, delegate : MyColorDialogDelegate) {
        let customAlerView = CustomIOSAlertView()
        let myColorView = myColorDialog(myColor: myColor, parrent: customAlerView!, delegate: delegate)
        customAlerView?.containerView = myColorView as UIView
        customAlerView?.useMotionEffects = true
        customAlerView?.buttonTitles = nil
        customAlerView?.show()
    }
    
    static func myColorDialog(myColor: MyColor, parrent : CustomIOSAlertView, delegate : MyColorDialogDelegate) -> MyColorDialog{
        let frame = CGRect(x: 0, y: 0, width: 300, height: 350)
        let pickView = MyColorDialog(frame: frame, myColor: myColor, parrent : parrent, delegate : delegate)
        return pickView
    }

}

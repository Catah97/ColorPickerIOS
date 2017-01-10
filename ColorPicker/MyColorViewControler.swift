//
//  MyColorViewControler.swift
//  ColorPicker
//
//  Created by Martin Beran on 11.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class MyColorViewControler : UITableViewController{
    
    var colors = [MyColor(color: UIColor.black, colorName: "cerna",colorMode: ColorMode.RGB),
                 MyColor(color: UIColor.blue, colorName: "modra",colorMode: ColorMode.CMYK),
                 MyColor(color: UIColor.yellow, colorName: "zluta",colorMode: ColorMode.HEX),
                 MyColor(color: UIColor.green, colorName: "zelena",colorMode: ColorMode.HSV)]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyColorCell
        let position = indexPath.row
        let myColor = colors[position]
        cell.colorExample.backgroundColor = myColor.color
        cell.colorName.text = myColor.colorName
        cell.colorValue.text = ColorMode.createColorValues(color : myColor.color, colorMode : myColor.colorMode)
        cell.selectionStyle = .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableView selected", indexPath.row)
        let position = indexPath.row;
        let color = colors[position]
        MyColorDialog.showUiAlert(myColor: color , controler: self)
    }
    
}

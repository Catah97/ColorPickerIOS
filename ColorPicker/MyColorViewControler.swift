//
//  MyColorViewControler.swift
//  ColorPicker
//
//  Created by Martin Beran on 11.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class MyColorViewControler : UITableViewController, MyColorDialogDelegate{
    
    var db : DBManager!
    var colors : Array<MyColor> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = DBManager()
        getData()
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
        MyColorDialog.showUiAlert(myColor: color , controler: self, delegate: self)
    }
    
    func tableView(selectedColorMode: ColorMode, myColor: MyColor) {
        db.updateMainColorMode(selectedColorMode: selectedColorMode, myColor: myColor)
        getData()
        tableView.reloadData()
    }
    
    private func getData(){
        do{
            colors = try db.getData();
        }
        catch let ex{
            print(ex)
            showGetDataError()
        }
    }
    
    private func showGetDataError(){
        let erroSheet = UIAlertController(title: "Chyba", message: "Data se nepodařilo načíst", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title : "Ok", style : .cancel) { (action) in}
        erroSheet.addAction(cancelAction)
        self.present(erroSheet, animated: true, completion: nil)
    }
}

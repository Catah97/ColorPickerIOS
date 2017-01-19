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
    

    @IBAction func onLongClick(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            let point = sender.location(in: self.tableView)
            let path = self.tableView.indexPathForRow(at: point)
            if path != nil {
                self.deselectRow(position: path!)
                showDeleteDialog(id: colors[(path?.row)!].ID, positionInList: path!)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyColorCell
        let position = indexPath.row
        let myColor = colors[position]
        setPreviewColor(cell: cell, myColor: myColor)
        cell.colorName.text = myColor.colorName
        cell.colorValue.text = ColorMode.createColorValues(color : myColor.color, colorMode : myColor.colorMode)
        return cell
    }
    
    
    func showDeleteDialog(id : Int, positionInList : IndexPath){
        let deleteAlert = UIAlertController(title: "Pozor", message: "Přejete si odstranit tento záznam?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title : "Ano", style : .default) { (action) in
            self.deleteRecord(id : id , positionInList: positionInList)
        }
        let cancelAction = UIAlertAction(title : "Ne", style : .destructive)
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(yesAction)
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    private func deleteRecord(id : Int, positionInList : IndexPath){
        do{
            try db.deleteRecord(id: id)
            tableView.beginUpdates()
            getData()
            tableView.deleteRows(at: [positionInList], with: UITableViewRowAnimation.left)
            tableView.endUpdates()
        } catch let deleteRowErrorEx{
            print("DeleteRowError")
            print(deleteRowErrorEx)
            showDeleteErrorAlert()
        }
    }
    
    
    private func setPreviewColor(cell : MyColorCell, myColor : MyColor){
        cell.colorExample.layer.borderWidth = 1
        cell.colorExample.layer.borderColor = UIColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        cell.colorExample.image = UIImage(color: myColor.color)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableView selected", indexPath.row)
        let position = indexPath.row;
        let color = colors[position]
        self.deselectRow(position: indexPath)
        MyColorDialog.showUiAlert(myColor: color , controler: self, delegate: self)
    }
    
    func tableView(selectedColorMode: ColorMode, myColor: MyColor) {
        do{
            try db.updateMainColorMode(selectedColorMode: selectedColorMode, myColor: myColor)
            getData()
            tableView.reloadData()
        } catch let updateErrorEx{
            print("updateMainColorModeError")
            print(updateErrorEx)
            showUpdateMainColorModeError()
        }
    }
    
    private func getData(){
        do{
            colors = try db.getData();
        }
        catch let ex{
            print("getDataError")
            print(ex)
            showGetDataError()
        }
    }
    
    private func showDeleteErrorAlert(){
        showDialog(title: "Záznam se nepodařilo smazat")
    }
    
    private func showUpdateMainColorModeError(){
        showDialog(title: "Aktualizaci se nepodařilo uložit")
    }
    
    private func showGetDataError(){
        showDialog(title: "Data se nepodařilo načíst")
    }
    
    private func showDialog(title : String){
        let erroSheet = UIAlertController(title: "Chyba", message: title, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title : "Ok", style : .cancel) { (action) in}
        erroSheet.addAction(cancelAction)
        self.present(erroSheet, animated: true, completion: nil)
    }
    
    private func deselectRow(position : IndexPath){
        self.tableView.deselectRow(at: position, animated: false)
    }
}

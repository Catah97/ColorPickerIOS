//
//  DBManager.swift
//  ColorPicker
//
//  Created by Martin Beran on 12.01.17.
//  Copyright © 2017 Martin Beran. All rights reserved.
//

import SQLite
import UIKit

class DBManager{
    
    var db : Connection!
    let colorsTable = Table("colors")
    
    var colors = [MyColor(color: UIColor.black, colorName: "cerna",colorMode: ColorMode.RGB, ID : 0),
                  MyColor(color: UIColor.blue, colorName: "modra",colorMode: ColorMode.CMYK, ID : 1),
                  MyColor(color: UIColor.yellow, colorName: "zluta",colorMode: ColorMode.HEX, ID : 2),
                  MyColor(color: UIColor.green, colorName: "zelena",colorMode: ColorMode.HSV, ID : 3)]

    let id = Expression<Int>("id")
    let name = Expression<String?>("name")
    let color = Expression<String>("color")
    let colorMode = Expression<String>("colorMode")

    
    
    init() {
        initDb()
    }
    
    private func initDb(){
        do{
        
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            self.db = try Connection("\(path)/db.sqlite3")
            createDB()
        }
        catch let initError{
            print("Cant coonect to DB");
            print(initError)
        }
    }
    
    private func createDB(){
        do{
            try db.run(colorsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(color)
                t.column(colorMode)
            })
        }
        catch let createTableError{
            print("Cant create table");
            print(createTableError)
        }
    }
    
    
    /* Všschny barvy jsou ukládany v RGB modelu*/
    public func insereData(myColor : MyColor) throws{
        let name = myColor.colorName
        let color = ColorMode.rgb(color: myColor.color).result
        let colorMode = myColor.colorMode
        try db.run(colorsTable.insert(self.name <- name, self.color <- color, self.colorMode <- String(describing: colorMode)))
    }
    
    public func getData() throws -> Array<MyColor>{
        var result = Array<MyColor>()
        for colorRecord in try db.prepare(colorsTable) {
            let id = colorRecord[self.id]
            let name = colorRecord[self.name];
            let color = ColorMode.color(colorInRGB: colorRecord[self.color])
            let colorMode = ColorMode.colorMode(value: colorRecord[self.colorMode]);
            result.append(MyColor(color: color, colorName: name!, colorMode: colorMode, ID: Int(id)))
            //print("id: \(user[id]), email: \(user[email]), name: \(user[name])")
            // id: 1, email: alice@mac.com, name: Optional("Alice")
        }
        return result
    }
    
    public func updateMainColorMode(selectedColorMode : ColorMode, myColor : MyColor) throws{
        let color = myColor
        color.colorMode = selectedColorMode
        let filter = colorsTable.filter(id == color.ID)
        if try db.run(filter.update(self.colorMode <- String(describing: selectedColorMode))) == 0 {
            throw NSError(domain: "No date updated", code: 1, userInfo: nil)
        }
    }
    
    public func deleteRecord(id : Int) throws{
        let filter = colorsTable.filter(self.id == id)
        if try db.run(filter.delete()) == 0 {
            throw NSError(domain: "No row deleted", code: 2, userInfo: nil)

        }
    }
}

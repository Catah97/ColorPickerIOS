//
//  Alerdialog.swift
//  HelloWorldProject
//
//  Created by Martin Beran on 27.09.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class Alerdialog {
    
    
    open static func showUiAlert(_ title: String, text : String, controler : UIViewController) {
        let uiAler = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: alerClick)
        uiAler.addAction(okAction)
        controler.present(uiAler, animated: true){
            print("Show dialog Completed")
        }
    }
    
    static func alerClick(_ alert: UIAlertAction!) {
        print("Clicked " + alert.title!)
    }
}

//
//  MyColorCell.swift
//  ColorPicker
//
//  Created by Martin Beran on 11.12.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class MyColorCell : UITableViewCell{
    
    @IBOutlet weak var colorExample: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

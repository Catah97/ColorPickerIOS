//
//  PhotoPickDialog.swift
//  ColorPicker
//
//  Created by Martin Beran on 27.10.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class PhotoPickDialog {
    
    open static func showUiAlert(color: UIColor, delegate : PhotoDialogDelegate, controler : UIViewController) {
        let customAlerView = CustomIOSAlertView()
        let photoDialogUIView = photoPickView(color: color, delegate: delegate)
        customAlerView?.containerView = photoDialogUIView as UIView
        customAlerView?.buttonTitles = ["Ok", "Cancel"]
        customAlerView?.delegate = photoDialogUIView
        customAlerView?.useMotionEffects = true
        customAlerView?.isButtonsVisible = true;
        customAlerView?.show()
        
        /*customAlerView
        
        // Add some custom content to the alert view
        [alertView setContainerView:[self createDemoView]];
        
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"ahoj", @"Close2", @"Close3", nil]];
        [alertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];*/
    }
    
    static func pick(_ alert: UIAlertAction!) {
        print("pick " + alert.title!)
    }
    
    static func photoPickView(color: UIColor, delegate : PhotoDialogDelegate) -> PhotoDialogUIView{
        let frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        let pickView = PhotoDialogUIView(frame: frame, color: color, delegate: delegate)
        return pickView
    }
}

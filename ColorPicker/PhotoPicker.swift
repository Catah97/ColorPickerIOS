//
//  PhotoPicker.swift
//  ColorPicker
//
//  Created by Martin Beran on 04.10.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit
import QuartzCore

class PhotoPicker: UIViewController, UIScrollViewDelegate, PhotoDialogDelegate {

    
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoColorUI: PhotoColorUIView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
    var lastColor : UIColor = UIColor.white
    var isSetted : Bool = false
    
    @IBAction func onPick(){
        PhotoPickDialog.showUiAlert(color: lastColor, delegate: self ,controler: self)
    }
    
    @IBAction func doubleTap(_ recognizer: UITapGestureRecognizer) {
        if let scrollV = self.scrollView {
            print(scrollV)
            if (scrollV.zoomScale > scrollV.minimumZoomScale) {
                scrollV.setZoomScale(scrollV.minimumZoomScale, animated: true)
            }
            else {
                //(I divide by 3.0 since I don't wan't to zoom to the max upon the double tap)
                let zoomRect = self.zoomRectForScale(scale: scrollV.maximumZoomScale, center: recognizer.location(in: recognizer.view))
                self.scrollView?.zoom(to: zoomRect, animated: true)
            }
        }
    }
    
    func zoomRectForScale(scale : CGFloat, center : CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        if let scrollView = self.scrollView {
            zoomRect.size.height = scrollView.frame.size.height / scale;
            zoomRect.size.width  = scrollView.frame.size.width  / scale;
            let newCenter = scrollView.convert(center, from: self.scrollView)
            zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2.0));
            zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2.0));
        }
        return zoomRect;
    }

    @IBAction func onColorChange(_ pin: UIPanGestureRecognizer) {
        let position = pin.location(in: self.imgPhoto);
        onColorChange(pos: position)
    }
    
    func onColorChange(pos : CGPoint) {
        var color : UIColor
        if  pos.x > 0 && pos.y > 0 &&
            pos.x < self.imgPhoto.bounds.width && pos.y < self.imgPhoto.bounds.height {
            color = self.imgPhoto.layer.colorOfPoint(point: pos);
        }
        else{
            color = UIColor.white
        }
        onColorChange(color: color)
    }
    
    func onColorChange() {
        let color = UIColor.white
        photoColorUI.onColorChange(color: color)
    }
    
    func onColorChange(color : UIColor) {
        lastColor = color
        photoColorUI.onColorChange(color: color)
    }
    
    
    open var image : UIImage?


    func getNextOrientation(img : UIImage, rotateRight : Bool) -> UIImageOrientation {
        switch img.imageOrientation{
        case UIImageOrientation.up:
                return rotateRight ? UIImageOrientation.right : UIImageOrientation.left
        case UIImageOrientation.right:
                return rotateRight ? UIImageOrientation.down : UIImageOrientation.up
        case UIImageOrientation.down:
            return rotateRight ? UIImageOrientation.left : UIImageOrientation.right
        case UIImageOrientation.left:
            return rotateRight ? UIImageOrientation.up : UIImageOrientation.down
        default:
            return UIImageOrientation.up
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onColorChange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isSetted {
            imgPhoto.image = image
            updateZoom()
            addNavigationBtn()
        }
        onColorChange(color: self.lastColor)
        isSetted = false
    }


    
    func addNavigationBtn() {
        let item = UIBarButtonItem(image: UIImage(named: "menuSmall"), style: .plain, target: self, action: #selector(PhotoPicker.optionMenuClick))
        self.navigationItem.title = "Color Picker"
        self.navigationItem.rightBarButtonItem = item
    }
    
    
    func optionMenuClick() {
        showOptionDialog()
    }
    
    func showOptionDialog()  {
        let myActionSheet = UIAlertController(title: "Možnoti", message: "Zvolte jednu z možností", preferredStyle: .actionSheet)
        
        // blue action button
        let turnLeftAction = UIAlertAction(title: "Otočit doleva", style: .default) { (action) in
            self.rotateImage(rotateRight: false)
        }
        
        // red action button
        let turnRightAction = UIAlertAction(title: "Otočit doprava", style: .default) { (action) in
            self.rotateImage(rotateRight: true)
            
        }
        
        // yellow action button
        let lupaAction = UIAlertAction(title: "Lupa", style: .default) { (action) in
        }
        
        // cancel action button
        let settingAction = UIAlertAction(title: "Nastavení", style: .default) { (action) in
            self.showSetting()
        }
        
        let myColorsAction = UIAlertAction(title: "Moje barvy", style: .default) { (action) in
            self.showMyColors()
        }
        
        let cancelAction = UIAlertAction(title : "Zrušit", style : .cancel) { (action) in
    
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(turnLeftAction)
        myActionSheet.addAction(turnRightAction)
        myActionSheet.addAction(lupaAction)
        myActionSheet.addAction(settingAction)
        myActionSheet.addAction(myColorsAction)
        myActionSheet.addAction(cancelAction)
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func rotateImage(rotateRight : Bool) {
        self.imgPhoto.image = self.rotateImage(img: self.imgPhoto.image!, orientation: self.getNextOrientation(img: self.imgPhoto.image!, rotateRight: rotateRight))
        updateZoom()
        updateConstraints()
    }
    
    func rotateImage(img : UIImage, orientation: UIImageOrientation) -> UIImage {
        let image = UIImage(cgImage: img.cgImage!, scale: 1.0, orientation: orientation)
        return image
        
    }

    func showSetting()  {
        isSetted = true
        let settingPick = self.storyboard?.instantiateViewController(withIdentifier: "SettingControler") as! SettingControler
        self.navigationController?.pushViewController(settingPick, animated: true)
    }
    
    func showMyColors() {
        isSetted = true
        let myColors = self.storyboard?.instantiateViewController(withIdentifier: "MyColors")
        self.navigationController?.pushViewController(myColors!, animated: true)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgPhoto
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll 
    func updateZoom() {
        if let image = self.imgPhoto.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                              scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    func updateConstraints() {
        if let image = self.imgPhoto.image {
            
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            
            
            // center image if it is smaller than the scroll view
            var wPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            
            if wPadding < 0 { wPadding = 0 }
            
            var hPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if hPadding < 0 { hPadding = 0 }

            
            imageConstraintLeft.constant = wPadding
            imageConstraintRight.constant = wPadding
            imageConstraintTop.constant = hPadding
            imageConstraintBottom.constant = hPadding
            
            view.layoutIfNeeded()
        }
    }
    
    func onOkClick(colorName: String, color: UIColor, mainColorMode: Int) {
        print("colorName is: " + colorName)
        print(mainColorMode)
    }
    

}

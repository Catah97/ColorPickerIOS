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

    @IBOutlet weak var magnifyingScrollView: UIScrollView!
    @IBOutlet weak var magnifyingView: UIImageView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoColorUI: PhotoColorUIView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    @IBOutlet weak var magnifyConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var magnifyConstraintLeft: NSLayoutConstraint!
    
    @IBOutlet weak var crossConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var crossConstraintLeft: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
    var lastColor : UIColor = UIColor.white
    var lastPoint : UIGestureRecognizer!
    var isMagnifyingOn : Bool = false
    var firstStart : Bool = false
    var db : DBManager!
    
    var image : UIImage?

    
    
    @IBAction func onPick(){
        PhotoPickDialog.showUiAlert(color: lastColor, delegate: self ,controler: self)
    }
    
    
    
    @IBAction func doubleTap(_ recognizer: UITapGestureRecognizer) {
        if let scrollV = self.scrollView {
            if (scrollV.zoomScale > scrollV.minimumZoomScale) {
                scrollV.setZoomScale(scrollV.minimumZoomScale, animated: true)
            }
            else {
                //(I divide by 3.0 since I don't wan't to zoom to the max upon the double tap)
                let zoomRect = self.zoomRectForScale(scale: scrollV.maximumZoomScale, center: recognizer.location(in: recognizer.view))
                scrollV.zoom(to: zoomRect, animated: true)
            }
        }
    }

    func onColorChange() {
        let color = UIColor.white
        photoColorUI.onColorChange(color: color)
    }
    
    func onColorChange(color : UIColor) {
        lastColor = color
        photoColorUI.onColorChange(color: color)
        
    }
    
    @IBAction func onColorChange(_ pin: UIPanGestureRecognizer) {
        onColorChange(pin : pin)
    }
    
    @IBAction func onColorChangeTab(_ pin: UITapGestureRecognizer) {
        onColorChange(pin : pin)
    }
    
    func zoomRectForScale(scale : CGFloat, center : CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        if let scrollView = self.scrollView {
            zoomRect.size.height = scrollView.frame.size.height / scale;
            zoomRect.size.width  = scrollView.frame.size.width  / scale;
            let newCenter = imgPhoto.convert(center, from: self.scrollView)
            zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2.0));
            zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2.0));
        }
        return zoomRect;
    }
    
    func onColorChange(pin: UIGestureRecognizer)
    {
        let position = pin.location(in: self.imgPhoto);
        let touchePostion = pin.location(in: self.scrollView)
        onColorChange(pos: position, touchePoint : touchePostion)
    }
    
    func onColorChange(pos : CGPoint, touchePoint : CGPoint) {
        self.scrollTo(point: pos)
        self.moveWithMagnifying(point: touchePoint)
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
        self.db = DBManager()
        addNavigationBtn()
        onColorChange()
        firstStart = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onColorChange(color: self.lastColor)
        if firstStart {
            self.imgPhoto.image = image
            self.magnifyingView.image = image
            updateZoom()
            updateConstraints()
        }
        firstStart = false
    }


    
    func addNavigationBtn() {
        let item = UIBarButtonItem(image: UIImage(named: "menuSmall"), style: .plain, target: self, action: #selector(PhotoPicker.optionMenuClick))
        item.tintColor = UIColor.darkText
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.title = "Color Picker"

    }
    
    
    func optionMenuClick() {
        showOptionDialog()
    }
    
    func showOptionDialog()  {
        let myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        myActionSheet.view.tintColor = UIColor.darkText
        //myActionSheet.setValue(attributedString, forKey: "attributedMessage")
        
        let turnLeftAction = UIAlertAction(title: "Otočit doleva", style: .default) { (action) in
            self.rotateImage(rotateRight: false)
        }
        
        let turnRightAction = UIAlertAction(title: "Otočit doprava", style: .default) { (action) in
            self.rotateImage(rotateRight: true)
            
        }
    
        let lupadString = isMagnifyingOn ? "Vypnout lupu" : "Zapnout lupu"
        let lupaAction = UIAlertAction(title: lupadString, style: .default) { (action) in
            self.isMagnifyingOn = !self.isMagnifyingOn
        }
        
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
        let image = self.rotateImage(img: self.imgPhoto.image!, orientation: self.getNextOrientation(img: self.imgPhoto.image!, rotateRight: rotateRight))
        self.imgPhoto.image = image
        self.magnifyingView.image = image
        updateZoom()
        updateConstraints()
    }
    
    func rotateImage(img : UIImage, orientation: UIImageOrientation) -> UIImage {
        let image = UIImage(cgImage: img.cgImage!, scale: 1.0, orientation: orientation)
        return image
        
    }

    func showSetting()  {
        let settingPick = self.storyboard?.instantiateViewController(withIdentifier: "SettingControler") as! SettingControler
        self.navigationController?.pushViewController(settingPick, animated: true)
    }
    
    func showMyColors() {
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
        
            print(minZoom)
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
            
            if wPadding < 0 {
                wPadding = 0
            }
            
            var hPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if hPadding < 0 {
                hPadding = 0
            }
            imageConstraintLeft.constant = wPadding
            imageConstraintRight.constant = wPadding
            imageConstraintTop.constant = hPadding
            imageConstraintBottom.constant = hPadding
            view.layoutIfNeeded()
        }
    }
    
    
    func scrollTo(point : CGPoint) {
        let x = point.x - 50;
        let y = point.y - 50
        magnifyConstraintLeft.constant = -x
        magnifyConstraintTop.constant = -y
        self.magnifyingScrollView.layoutIfNeeded()
        let offset = self.magnifyingScrollView.contentOffset
        let leftEdge = offset.x
        let topEdge = offset.y
        crossConstraintLeft.constant = leftEdge
        crossConstraintTop.constant = topEdge

    }
    
    func moveWithMagnifying(point : CGPoint) {
        let scrollViewWidth = self.scrollView.frame.width
        
        let offset = self.scrollView.contentOffset
        
        let leftEdge = offset.x
        let rightEdge = offset.x + scrollViewWidth
        let topEdge = offset.y
        var x = point.x
        var y = point.y - 80
        if x - 50 < leftEdge {
            x = leftEdge + 50
        }
        if x + 50 > rightEdge{
            x = rightEdge - 50
        }
        if y - 80 < topEdge{
            y = point.y + 80
        }
        let magnifyPoint = CGPoint(x: x, y: y)
            self.magnifyingScrollView.isHidden = !self.isMagnifyingOn
            self.magnifyingScrollView.center = magnifyPoint;
    }
    
    func onOkClick(colorName: String, color: UIColor, mainColorMode: ColorMode) {
        let myColor = MyColor(color: color, colorName: colorName, colorMode: mainColorMode, ID: -1)
        do{
            try db.insereData(myColor: myColor)
        }
        catch let ex{
            print(ex)
            showSaveErroDialog()
        }
    }
    
    func showSaveErroDialog()  {
        let erroSheet = UIAlertController(title: "Chyba", message: "Hodnotu se nepodařilo uložit", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title : "Ok", style : .cancel) { (action) in}
        erroSheet.addAction(cancelAction)
        self.present(erroSheet, animated: true, completion: nil)
    }
    
}

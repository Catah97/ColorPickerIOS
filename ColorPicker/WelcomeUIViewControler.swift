//
//  WelcomeUIViewControler.swift
//  ColorPicker
//
//  Created by Martin Beran on 28.09.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

class WelcomeUIViewControler: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var btnAlbum: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnInternet: UIButton!
    var isShowed : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBtn()
    }
    
    func addNavigationBtn() {
        let item = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action:
            #selector(WelcomeUIViewControler.onStartSettingClick))
        item.tintColor = UIColor.darkText
        self.navigationItem.rightBarButtonItem = item
    }
    
    func onStartSettingClick() {
        let settingPick = self.storyboard?.instantiateViewController(withIdentifier: "SettingControler") as! SettingControler
        self.navigationController?.pushViewController(settingPick, animated: true)
    }
    
    @IBAction func plusBtnClick() {
        startAnimation(show: !self.isShowed)
    }
    @IBAction func startInternetBtn() {
        startInternet()
    }
    
    @IBAction func startGaleryBtn() {
        startGalery()
    }
    @IBAction func startCameraBtn() {
        startCamera()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        startPhotoViewController(image : pickedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func startPhotoViewController(image : UIImage) {
        let photoPick = self.storyboard?.instantiateViewController(withIdentifier: "PhotoPicker") as! PhotoPicker
        photoPick.image = image
        self.navigationController?.pushViewController(photoPick, animated: true)
    }
    
    func startGalery()  {
        startImagePick(type: .photoLibrary)
    }
    
    func startCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            startImagePick(type: .camera)
        }
        else{
            Alerdialog.showUiAlert("Error", text: "Camera is no available", controler: self)
        }
    }
    
    func startImagePick(type : UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func startInternet() {
        let application:UIApplication = UIApplication.shared
        let url = URL(string: "https://www.google.cz")
        if application.canOpenURL(url!){
            application.openURL(url!)
            
        }
        else{
            Alerdialog.showUiAlert("Error", text: "Device is not connected to internet", controler: self)
        }
    }
    
    func startAnimation(show: Bool) {
        print("startAnimation show: " + String(show))
        self.isShowed = show
        self.plusBtn.isEnabled = false;
        let animDuration = 0.5
        if show {
            UIView.animate(withDuration: TimeInterval(animDuration),
                           animations: {
                            self.setAlpha(view: self.btnAlbum, alpha: 1)
                            self.setPostion(view: self.btnAlbum,
                                            cgX: self.getAlbumShowedPosition().x,
                                            cgY: self.getAlbumShowedPosition().y)
                            
                            self.setAlpha(view: self.btnCamera, alpha: 1)
                            self.setPostion(view: self.btnCamera,
                                            cgX: self.getCameraShowedPosition().x,
                                            cgY: self.getCameraShowedPosition().y)
                            
                            self.setAlpha(view: self.btnInternet, alpha: 1)
                            self.setPostion(view: self.btnInternet,
                                            cgX: self.getInternetShowedPosition().x,
                                            cgY: self.getInternetShowedPosition().y)
                }, completion: { finish in
                    self.plusBtn.isEnabled = true;
            })
        }
        else{
            UIView.animate(withDuration: TimeInterval(animDuration),
                           animations: {
                            self.setAlpha(view: self.btnAlbum, alpha: 0)
                            self.setPostion(view: self.btnAlbum,
                                            cgX: self.getDefaultPosition().x,
                                            cgY: self.getDefaultPosition().y)
                            
                            self.setAlpha(view: self.btnCamera, alpha: 0)
                            self.setPostion(view: self.btnCamera,
                                            cgX: self.getDefaultPosition().x,
                                            cgY: self.getDefaultPosition().y)
                            
                            self.setAlpha(view: self.btnInternet, alpha: 0)
                            self.setPostion(view: self.btnInternet,
                                            cgX: self.getDefaultPosition().x,
                                            cgY: self.getDefaultPosition().y)
                }, completion: { finish in
                    self.plusBtn.isEnabled = true;
            })
        }
    }

    
    func setAlpha(view : UIView, alpha : Int) {
        view.alpha = CGFloat(alpha);
    }
    
    func setPostion(view : UIView, x : Int, y : Int) {
        view.center.x = CGFloat(x)
        view.center.y = CGFloat(y)
    }
    
    func setPostion(view : UIView, cgX : CGFloat, cgY : CGFloat) {
        view.center.x = cgX
        view.center.y = cgY
    }
    
    func getAlbumShowedPosition() -> (x: CGFloat, y: CGFloat) {
        let x = plusBtn.center.x - btnAlbum.bounds.width - 8
        let y = plusBtn.center.y - btnAlbum.bounds.height - 8
        return (x, y)
    }
    
    func getCameraShowedPosition() -> (x: CGFloat, y: CGFloat) {
        let x = plusBtn.center.x + btnAlbum.bounds.width + 8
        let y = plusBtn.center.y - btnAlbum.bounds.height - 8
        return (x, y)
    }
    
    func getInternetShowedPosition() -> (x: CGFloat, y: CGFloat) {
        let x = plusBtn.center.x
        let y = plusBtn.center.y + btnInternet.bounds.height + 8
        return (x, y)
    }
    
    func getDefaultPosition() -> (x: CGFloat, y: CGFloat) {
        let x = plusBtn.center.x
        let y = plusBtn.center.y
        return (x, y)
    }
}

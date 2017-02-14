//
//  AppDelegate.swift
//  ColorPicker
//
//  Created by Martin Beran on 22.11.16.
//  Copyright © 2016 Martin Beran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print(" App shorcut selected: " + shortcutItem.type)
        if shortcutItem.type == "galery" {
            startGalery()
        }
        else if shortcutItem.type == "camera"{
            startCamera()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let viewControler = self.window?.rootViewController as! UINavigationController
        let pickedImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        startPhotoViewController(navigationControler: viewControler, image : pickedImage)
    }
    
    func startPhotoViewController(navigationControler : UINavigationController, image : UIImage) {
        let photoPick = navigationControler.storyboard?.instantiateViewController(withIdentifier: "PhotoPicker") as! PhotoPicker
        print(photoPick)
        photoPick.image = image
        navigationControler.pushViewController(photoPick, animated: true)
        navigationControler.dismiss(animated: true, completion: nil)
    }
 
    func startGalery()  {
        startImagePick(type: .photoLibrary)
    }
    
    func startCamera() {
        let viewControler = self.window?.rootViewController
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            startImagePick(type: .camera)
        }
        else{
            Alerdialog.showUiAlert("Error", text: "Camera is no available", controler: viewControler!)
        }
    }
    
    func startImagePick(type : UIImagePickerControllerSourceType) {
        let viewControler = self.window?.rootViewController
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        viewControler?.present(imagePicker, animated: true, completion: nil)
    }
}


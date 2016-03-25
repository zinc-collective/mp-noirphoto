//
//  AppDelegate.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/23/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit


let SaveOriginPhotoPath = "/Documents/origin_photo.jpg"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SplashDelegate {

    var window: UIWindow?
    
    var splashController : SplashViewController!
    var viewController : NoirViewController!
    var navigationController : NavigationViewController!
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.navigationController = self.window!.rootViewController as! NavigationViewController
        
        self.splashController = UIStoryboard(name: "Splash", bundle: nil)
                                    .instantiateViewControllerWithIdentifier("SplashViewController") as! SplashViewController
        self.splashController.delegate = self
        self.viewController = NoirScaleHackViewController(nibName: "NoirViewController", bundle: nil)
        
        // load last used photo
//        if self.checkPhotoExistFromPath(SaveOriginPhotoPath) {
//            let image = self.viewController.loadPhotoFromPath(SaveOriginPhotoPath)!
//            self.navigationController.viewControllers = [self.viewController]
//            self.viewController.loadWithSavedPhoto(image)
//        }
//        else {
            self.navigationController.viewControllers = [self.splashController]
//        }
        
        // HACK: scale view controller, until we have time to fix it
//        print("WIDTH", self.viewController.view.frame.size)
//        self.viewController.view.transform = CGAffineTransformMakeScale(1.2, 1.2)
        
        return true
    }
    
    func splashDidPickImage(image: UIImage, url: NSURL) {
        self.viewController.pickPhoto(url, image: image)
        self.navigationController.viewControllers = [self.viewController]
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        viewController.savePresetToUserDefault()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        viewController.savePresetToUserDefault()
    }
    
    
    func checkPhotoExistFromPath(path: String) -> Bool
    {
    	let filePath = NSHomeDirectory().stringByAppendingString(path)
    	return NSFileManager.defaultManager().fileExistsAtPath(filePath)
    }


}


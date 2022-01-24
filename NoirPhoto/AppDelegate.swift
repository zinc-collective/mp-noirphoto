//
//  AppDelegate.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/23/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Photos
import Fabric
import Crashlytics

let SaveOriginPhotoPath = "/Documents/origin_photo.jpg"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SplashDelegate {

    var window: UIWindow?

    var splashController : SplashViewController!
    var viewController : NoirViewController!
    var navigationController : NavigationViewController!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.navigationController = self.window!.rootViewController as! NavigationViewController

        Fabric.with([Crashlytics.self])

        self.splashController = UIStoryboard(name: "Splash", bundle: nil)
                                    .instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        self.splashController.delegate = self

        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            self.viewController = NoirViewController(nibName: "NoirViewController-iPad", bundle: nil)
        }
        else {
            self.viewController = NoirViewController(nibName: "NoirViewController", bundle: nil)
        }

        self.navigationController.viewControllers = [self.splashController]


        return true
    }

    func splashDidPickImage(_ image: UIImage, url: URL) {
        self.navigationController.viewControllers = [self.viewController]
        // this must go last (refactor needed)
        self.viewController.pickPhoto(url, image: image)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


    func checkPhotoExistFromPath(_ path: String) -> Bool
    {
    	let filePath = NSHomeDirectory() + path
    	return FileManager.default.fileExists(atPath: filePath)
    }


}


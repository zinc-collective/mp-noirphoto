//
//  AppDelegate.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/23/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Photos
import Sentry

let SaveOriginPhotoPath = "/Documents/origin_photo.jpg"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        var config: InfoConfiguration
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            config = InfoConfiguration(buttonLeftMarginValue: 16.0,
                                       buttonTopMarginValue: 24.0,
                                       buttonSideValue: 37.0,
                                       scrollViewInsetSize: 56.0,
                                       defaultFontSize: 28.0)
        } else {
            config = InfoConfiguration(buttonLeftMarginValue: 8.0,
                                       buttonTopMarginValue: 16.0,
                                       buttonSideValue: 37.0,
                                       scrollViewInsetSize: 32.0,
                                       defaultFontSize: 50.0)
        }
        
        let vc = NoirViewController()
        vc.infoVC = createFactoryInfoViewController(configuration: config)
        let splashController: SplashViewController = UIStoryboard(name: "Splash", bundle: nil)
                                    .instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        splashController.logger = LogManager()
        splashController.imageProvider = PhotoLibraryCoordinator(parent: splashController)
        splashController.infoVC = createFactoryInfoViewController(configuration: config)
        splashController.viewController = vc as? ImageEditorInterfaceProvider
           
        let navigationController: UINavigationController = UINavigationController(rootViewController: splashController)
        self.window!.rootViewController = navigationController
        return true
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

    private func createFactoryInfoViewController(configuration: InfoConfiguration) -> () -> InfoViewController {
        return { return InfoViewController(configuration: configuration) }
    }
}


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
        
        setupAnalytics()
        
        var config: InfoConfiguration
        var noirConfig: NoirConfiguration
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            config = InfoConfiguration(buttonLeftMarginValue: 16.0,
                                       buttonTopMarginValue: 24.0,
                                       buttonSideValue: 37.0,
                                       scrollViewInsetSize: 56.0,
                                       defaultFontSize: 28.0)
//            noirConfig = NoirConfiguration(tintMaskImage: "tint_mask_iPad_0.png")
            noirConfig = NoirConfiguration(tintMaskImage: "tint_mask_1.png")
        } else {
            config = InfoConfiguration(buttonLeftMarginValue: 8.0,
                                       buttonTopMarginValue: 16.0,
                                       buttonSideValue: 37.0,
                                       scrollViewInsetSize: 32.0,
                                       defaultFontSize: 60.0)
            noirConfig = NoirConfiguration(tintMaskImage: "tint_mask_1.png")
        }
        
        let vc = NoirViewController(configuration: noirConfig, shareAgent: ShareService())
        vc.infoVC = createFactoryInfoViewController(configuration: config)
        vc.logger = LogManager()
        vc.imageProvider = PhotoLibraryCoordinator(parent: vc as! UIViewController)
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
    
    func getAppLogger() -> AppLogger {
        return LogManager()
    }

    private func createFactoryInfoViewController(configuration: InfoConfiguration) -> () -> InfoViewController {
        return { return InfoViewController(configuration: configuration) }
    }
}


private extension AppDelegate {
    func setupAnalytics() {
        //Add Sentry
        SentrySDK.start { options in
            options.dsn = "https://560a0707df8045059ed6873673cb5c0a@o268108.ingest.us.sentry.io/4503926177726464"
            options.debug = false; // Enabled debug when first installing is always helpful
            // Example uniform sample rate: capture 100% of transactions for performance monitoring
            options.tracesSampleRate = 1.0
            
            // Features turned off by default, but worth checking out
            options.enableAppHangTracking = true
            options.enableFileIOTracing = true
            options.enableCoreDataTracing = true
            
            // Enable all experimental features
            options.enableUserInteractionTracing = true
            options.attachScreenshot = true
            options.attachViewHierarchy = true
        }
    }
}



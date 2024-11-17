//
//  AppDelegate.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/23/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Sentry

let SaveOriginPhotoPath = "/Documents/origin_photo.jpg"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupAnalytics()
        return true
    }
    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
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

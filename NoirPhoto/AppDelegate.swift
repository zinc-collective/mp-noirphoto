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
        var ctrlPadConfig: ControlPadConfiguration
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            config = InfoConfiguration(buttonLeftMarginValue: 16.0,
                                       buttonTopMarginValue: 24.0,
                                       buttonSideValue: 37.0,
                                       scrollViewInsetSize: 56.0,
                                       defaultFontSize: 28.0)
//            noirConfig = NoirConfiguration(tintMaskImage: "tint_mask_iPad_0.png")
            noirConfig = NoirConfiguration(tintMaskImage: "tint_mask_1.png")
            
            ctrlPadConfig = ControlPadConfiguration(frame:                  CGRectMake(0.0, 768.0, 768.0, 256.0),
                                                    resetButtonRect:        CGRectMake(280.0, 20.0, 30.0, 30.0),
                                                    presetsConfig:          PresetsConfiguration(frame: ControlPadView.Frames.presetsRectIPad,
                                                                                                 buttonSize: CGSize(width: 80.0, height: 80.0)),
                                                    tintsConfig:            TintsConfiguration(frame: ControlPadView.Frames.tintsRectIPad,
                                                                                               buttonSize: CGSize(width: 85.0, height: 85.0)),
                                                    adjustsConfig:          AdjustConfiguration(frame: ControlPadView.Frames.adjustsRectIPad),
                                                    primaryBtnConfig:       ButtonConfiguration(frame: CGRectMake(0.0, 0.0, 47.0, 47.0),
                                                                                                imageName: "btn_load-iPad.png"),
                                                    secondaryBtnConfig:     ButtonConfiguration(frame: CGRectMake(0.0, 0.0, 47.0, 47.0),
                                                                                                imageName: "btn_save-iPad.png"),
                                                    auxBtnConfig:           ButtonConfiguration(frame: CGRectMake(0.0, 0.0, 39.0, 39.0),
                                                                                                imageName: "btn_home_info-iPad.png"),
                                                    imageName:              "ctrl_pad_bg-iPad.png",
                                                    btnPosition:            ButtonPositionConfiguration(panelBottomOffsetRowTop: 76.4317,
                                                                                                        panelBottomOffsetRowBottom: 18.4173,
                                                                                                        panelTrailingOffsetRowTop: 20.2590,
                                                                                                        panelTrailingOffsetRowBottom: 28.5468,
                                                                                                        marginBetweenRows: 21.1799))
        } else {
            config = InfoConfiguration(buttonLeftMarginValue: 8.0,
                                       buttonTopMarginValue: 16.0,
                                       buttonSideValue: 37.0,
                                       scrollViewInsetSize: 32.0,
                                       defaultFontSize: 60.0)
            noirConfig = NoirConfiguration(tintMaskImage: "tint_mask_1.png")
            
            ctrlPadConfig = ControlPadConfiguration(frame:                  CGRectMake(0.0, 0.0, 320.0, 480),
                                                    resetButtonRect:        CGRectMake(280.0, 20.0, 30.0, 30.0),
                                                    presetsConfig:          PresetsConfiguration(frame: ControlPadView.Frames.presetsRect2,
                                                                                                 buttonSize: CGSize(width: 42.0, height: 32.0)),
                                                    tintsConfig:            TintsConfiguration(frame: ControlPadView.Frames.tintsRect,
                                                                                               buttonSize: CGSize(width: 50.0, height: 50.0)),
                                                    adjustsConfig:          AdjustConfiguration(frame: ControlPadView.Frames.adjustsRect),
                                                    primaryBtnConfig:       ButtonConfiguration(frame: CGRectMake(0.0, 0.0, 40.0, 40.0),
                                                                                                imageName: "btn_load.png"),
                                                    secondaryBtnConfig:     ButtonConfiguration(frame: CGRectMake(0.0, 0.0, 40.0, 40.0),
                                                                                                imageName: "btn_save.png"),
                                                    auxBtnConfig:           ButtonConfiguration(frame: CGRectMake(0.0, 0.0, 24.0, 24.0),
                                                                                                imageName: "btn_home_info.png"),
                                                    imageName:              "ctrl_pad_bg.png",
                                                    btnPosition:            ButtonPositionConfiguration(panelBottomOffsetRowTop: 0,
                                                                                                        panelBottomOffsetRowBottom: 0,
                                                                                                        panelTrailingOffsetRowTop: 0,
                                                                                                        panelTrailingOffsetRowBottom: 0,
                                                                                                        marginBetweenRows: 0))
        }
        
        let vc = NoirViewController(configuration: noirConfig,
                                    shareAgent: ShareService(),
                                    ctrlPadConfig: ctrlPadConfig)
        vc.infoVC = createFactoryInfoViewController(configuration: config)
        vc.logger = LogManager()
        vc.imageProvider = PhotoLibraryCoordinator(parent: vc as UIViewController)
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
        //TODO: - SentrySDK handle key better
        #warning("SentrySDK\n 1. Need to replace this API ID Key and inject at buildtime.\n 2. Need a method to upate key remotely.")
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

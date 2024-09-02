//
//  SceneDelegate.swift
//  NoirPhoto
//
//  Created by Cricket on 9/3/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            
            var viewController: NoirViewController
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                viewController = NoirViewController(nibName: "NoirViewController-iPad", bundle: nil)
            } else {
                viewController = NoirViewController(nibName: "NoirViewController", bundle: nil)
            }
            viewController.logger = LogManager()
            viewController.imageProvider = PhotoLibraryCoordinator(parent: viewController as UIViewController)
            
            
            let splashController: SplashViewController = UIStoryboard(name: "Splash", bundle: nil)
                                        .instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            splashController.logger = LogManager()
            splashController.imageProvider = PhotoLibraryCoordinator(parent: splashController)
            splashController.viewController = viewController as ImageEditorInterfaceProvider
                        
            window = UIWindow(windowScene: windowScene)
            window!.rootViewController = UINavigationController(rootViewController: splashController)
            window!.makeKeyAndVisible()
        }
    }
}

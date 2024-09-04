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
                viewController = NoirViewController(nibName: "NoirViewController-iPad", bundle: nil, shareAgent: ShareService())
            } else {
                viewController = NoirViewController(nibName: "NoirViewController", bundle: nil, shareAgent: ShareService())
            }
            viewController.logger = LogManager()
            viewController.imageProvider = PhotoLibraryCoordinator(parent: viewController as UIViewController)
            viewController.delegate = viewController
            viewController.infoVC = UIViewControllerFactory().createFactoryInfoViewController()
            
            
            let splashController: SplashViewController = UIStoryboard(name: "Splash", bundle: nil)
                                        .instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            splashController.logger = LogManager()
            splashController.imageProvider = PhotoLibraryCoordinator(parent: splashController)
            splashController.viewController = viewController as ImageEditorInterfaceProvider
            splashController.delegate = splashController
            splashController.infoVC = UIViewControllerFactory().createFactoryInfoViewController()
                        
            window = UIWindow(windowScene: windowScene)
            window!.rootViewController = UINavigationController(rootViewController: splashController)
            window!.makeKeyAndVisible()
        }
    }
}


// for iOS 13+
enum SceneExtError: Error {
    case windowSceneNotFound
}

extension UIScene {
    static var interfaceOrientation: UIInterfaceOrientation? {
        let scenes = UIApplication.shared.connectedScenes
        if let windowScenes = scenes.first as? UIWindowScene {
            return windowScenes.interfaceOrientation
        } else {
            AppDelegate().getAppLogger().logError(SceneExtError.windowSceneNotFound)
            assertionFailure("Could not obtain UIInterfaceOrientation from a valid windowScene")
            return nil
        }
    }
    static var isLandscape: Bool {
        return Self.interfaceOrientation?.isLandscape ?? false
    }
}

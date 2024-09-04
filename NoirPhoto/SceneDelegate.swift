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
            let factory: ViewControllerFactory = UIViewControllerFactory()
            let viewController: NoirViewController = factory.createNoirViewController()
            let splashController: SplashViewController = factory.createSplashViewController(viewController: viewController)
            
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

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
            
            window = self.window ?? UIWindow(windowScene: windowScene)
            window?.windowScene = windowScene
            window!.rootViewController = UINavigationController(rootViewController: splashController)
            window!.makeKeyAndVisible()
        }
    }
}

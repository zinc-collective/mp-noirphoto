//
//  UIViewControllerFactory.swift
//  NoirPhoto
//
//  Created by Cricket on 9/4/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit


protocol ViewControllerFactory {
    func createNoirViewController() -> NoirViewController
    func createSplashViewController(viewController: ImageEditorInterfaceProvider) -> SplashViewController
    func createFactoryInfoViewController() -> () -> InfoViewController
}


class UIViewControllerFactory: ViewControllerFactory {
    private let createLogger: () -> AppLogger
    private let createLibrary: (UIViewController) -> PhotoLibraryCoordinator
    
    private var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    init(createLogger: @escaping () -> AppLogger = { return LogManager() },
         createLibrary: @escaping (UIViewController) -> PhotoLibraryCoordinator = { parent in return PhotoLibraryCoordinator(parent: parent) }) {
        self.createLogger = createLogger
        self.createLibrary = createLibrary
    }
    
    func createNoirViewController() -> NoirViewController {
        let nibName: String = self.isIPad ? "NoirViewController-iPad" : "NoirViewController"
        let viewController = NoirViewController(nibName: nibName, bundle: nil, shareAgent: ShareService())
        viewController.logger = createLogger()
        viewController.imageProvider = self.createLibrary(viewController)
        viewController.delegate = viewController
        viewController.infoVC = self.createFactoryInfoViewController()
        return viewController
    }
    
    func createSplashViewController(viewController: ImageEditorInterfaceProvider) -> SplashViewController {
        let splashController: SplashViewController = UIStoryboard(name: "Splash", bundle: nil)
                                    .instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        splashController.logger = createLogger()
        splashController.imageProvider = self.createLibrary(splashController)
        splashController.viewController = viewController as ImageEditorInterfaceProvider
        splashController.delegate = splashController
        splashController.infoVC = self.createFactoryInfoViewController()
        return splashController
    }
    
    func createFactoryInfoViewController() -> () -> InfoViewController {
        var config: InfoConfiguration
        if(self.isIPad) {
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
                                       defaultFontSize: 60.0)
        }
        return { return InfoViewController(configuration: config) }
    }
}

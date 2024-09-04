//
//  UIViewControllerFactory.swift
//  NoirPhoto
//
//  Created by Cricket on 9/4/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit

class UIViewControllerFactory {
    private var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    func createNoirViewController() -> NoirViewController {
        let nibName: String = self.isIPad ? "NoirViewController-iPad" : "NoirViewController"
        let viewController = NoirViewController(nibName: nibName, bundle: nil, shareAgent: ShareService())
        viewController.logger = LogManager()
        viewController.imageProvider = PhotoLibraryCoordinator(parent: viewController as UIViewController)
        viewController.delegate = viewController
        viewController.infoVC = self.createFactoryInfoViewController()
        return viewController
    }
    
    func createSplashViewController(viewController: ImageEditorInterfaceProvider) -> SplashViewController {
        let splashController: SplashViewController = UIStoryboard(name: "Splash", bundle: nil)
                                    .instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        splashController.logger = LogManager()
        splashController.imageProvider = PhotoLibraryCoordinator(parent: splashController)
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

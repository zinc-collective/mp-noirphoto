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

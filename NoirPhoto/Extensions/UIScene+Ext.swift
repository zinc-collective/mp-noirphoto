//
//  UIScene+Ext.swift
//  NoirPhoto
//
//  Created by Cricket on 4/8/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation

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

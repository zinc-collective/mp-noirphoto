//
//  UIScene+Ext.swift
//  NoirPhoto
//
//  Created by Cricket on 4/8/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation

// for iOS 13+
// in the future this should come from a UIWindowScene.windows
extension UIScene {
    static var interfaceOrientation: UIInterfaceOrientation? {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScenes = scenes.first as? UIWindowScene else {
            fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
            return nil
        }
        return windowScenes.interfaceOrientation
    }
    static var isPortrait: Bool {
        return Self.interfaceOrientation?.isPortrait ?? false
    }
}

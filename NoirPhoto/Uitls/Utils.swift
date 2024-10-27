//
//  Utils.swift
//  NoirPhoto
//
//  Created by Sean Hess on 5/24/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure)
}

enum Alert {
    static func showAlert(on viewController: UIViewController,
                   title: String,
                   message: String,
                   action handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        DispatchQueue.mainAsyncIfNeeded {
            viewController.presentedViewController?.dismiss(animated: false)
            viewController.present(alert, animated: true)
        }
    }
}

extension DispatchQueue {
    static func mainAsyncIfNeeded(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            main.async(execute: work)
        }
    }
}

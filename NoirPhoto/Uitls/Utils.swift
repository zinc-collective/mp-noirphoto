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


extension UIView {
    enum OffsetGuide: CaseIterable {
        case top
        case bottom
        case leading
        case trailing
    }
    
    func pinToEdges(of superview: UIView, constrainToMargins: Bool = false, offsets: [OffsetGuide: Double] = [:]) {
        var rules: [NSLayoutConstraint]?
        translatesAutoresizingMaskIntoConstraints = false
        if constrainToMargins {
            rules = [
                topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: offsets[.top] ?? 0),
                leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor, constant: offsets[.leading] ?? 0),
                trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor, constant: offsets[.trailing] ?? 0),
                bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: offsets[.bottom] ?? 0)
            ]
        } else {
            rules = [
                topAnchor.constraint(equalTo: superview.topAnchor, constant: offsets[.top] ?? 0),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: offsets[.leading] ?? 0),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: offsets[.trailing] ?? 0),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: offsets[.bottom] ?? 0)
            ]
        }
        NSLayoutConstraint.activate(rules!)
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

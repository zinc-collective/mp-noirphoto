//
//  ShareService.swift
//  NoirPhoto
//
//  Created by Cricket on 9/4/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit


enum ShareableActivityType: String {
    case saveToCameraRoll
}

protocol ShareableActivityProvider {
    typealias ActivityType = ShareableActivityType
    typealias ProviderCompletion = (ActivityType, Bool, [Any]?, Error?) -> Void
    func shareItem(sender parent: UIViewController,
                   sourceRect: CGRect,
                   data: Data?,
                   title: String,
                   subtitle: String?,
                   completion: ProviderCompletion?)
}


final class ShareService: ShareableActivityProvider {
    private(set) weak var parent: UIViewController?
    var shareCompletion: ShareableActivityProvider.ProviderCompletion?
    
    func shareItem(sender parent: UIViewController,
                   sourceRect: CGRect,
                   data: Data?,
                   title: String,
                   subtitle: String? = nil,
                   completion: ShareableActivityProvider.ProviderCompletion? = nil) {
        self.parent = parent
        if let data = data,
           let image = UIImage(data: data),
           let parent = self.parent {
            let shareItem = ShareableItem(image: image,
                                          title: title,
                                          subtitle: subtitle)
            let activity = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
            
            // TODO: check for iPad compatability
            activity.popoverPresentationController?.sourceView = parent.view
            activity.popoverPresentationController?.sourceRect = sourceRect
            activity.completionWithItemsHandler = { activity, completed, returnedItems, error in
                completion?(UIActivity.ActivityType.convert(activity), completed, returnedItems, error)
            }
            parent.present(activity, animated: true, completion: nil)
        }
    }
}


extension UIActivity.ActivityType {
    static let defaultResponse: ShareableActivityProvider.ActivityType = .saveToCameraRoll
    static func convert(_ deviceActivityType: UIActivity.ActivityType?) -> ShareableActivityProvider.ActivityType {
        if let type = deviceActivityType {
            switch type {
            case .saveToCameraRoll:
                return .saveToCameraRoll
            default:
                return Self.defaultResponse
            }
        } else {
            return Self.defaultResponse
        }
    }
}


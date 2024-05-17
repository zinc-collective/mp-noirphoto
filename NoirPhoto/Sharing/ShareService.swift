//
//  ShareService.swift
//  NoirPhoto
//
//  Created by Cricket on 5/18/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit


protocol SharableActivityProvider {
    func shareItem(sender parent: UIViewController,
                   sourceRect: CGRect,
                   data: Data?,
                   title: String,
                   subtitle: String?,
                   completion: UIActivityViewController.CompletionWithItemsHandler?)
}


final class ShareService: SharableActivityProvider {
    private(set) weak var parent: UIViewController?
    
    func shareItem(sender parent: UIViewController,
                   sourceRect: CGRect,
                   data: Data?,
                   title: String,
                   subtitle: String? = nil,
                   completion: UIActivityViewController.CompletionWithItemsHandler?) {
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
            activity.completionWithItemsHandler = completion
            parent.present(activity, animated: true, completion: nil)
        }
    }
}

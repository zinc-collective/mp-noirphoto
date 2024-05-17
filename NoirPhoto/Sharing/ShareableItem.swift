//
//  ShareableItem.swift
//  NoirPhoto
//
//  Created by Cricket on 5/18/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit
import LinkPresentation


final class ShareableItem: NSObject, UIActivityItemSource {
    static let activityViewIconName = "activityViewIcon"
    private let image: UIImage
    private let title: String
    private let subtitle: String?

    init(image: UIImage, title: String, subtitle: String? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle

        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: Self.activityViewIconName)!
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()

        metadata.iconProvider = NSItemProvider(object: UIImage(named: Self.activityViewIconName)!)
        metadata.title = title
        if let subtitle = subtitle {
            metadata.originalURL = URL(fileURLWithPath: subtitle)
        }

        return metadata
    }
}

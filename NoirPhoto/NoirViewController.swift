//
//  NoirScaleHackViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Photos
import ImageIO
import MobileCoreServices

// scales up the whole view, just like if we weren't supporting iPhone 6 or 6+
class NoirViewController: NoirViewControllerLegacy {

    // SCALE HACK: remove me once we change the UI
    override func viewWillAppear(animated: Bool) {
        if (UI_USER_INTERFACE_IDIOM() == .Phone) {
            let scale = self.view.frame.size.width / CGFloat(320)
            self.view.transform = CGAffineTransformMakeScale(scale, scale)
            super.viewWillAppear(animated)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(NoirViewController.onSwipeGripDown))
        downGesture.direction = .Down

        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(NoirViewController.onSwipeGripUp))
        upGesture.direction = .Up

        self.fullBtn.addGestureRecognizer(downGesture)
        self.fullBtn.addGestureRecognizer(upGesture)
    }

    @IBAction func onSwipeGripDown() {
        print("SWIPE DOWN")

        if (!isFull) {
            self.toggleFull()
        }

    }

    @IBAction func onSwipeGripUp() {
        print("SWIPE UP")

        if (isFull) {
            self.toggleFull()
        }
    }

    @IBAction func onTapShare() {
        // TODO: render after share like in Plastic Bullet? Or in the background?

        let meta = UIImage.stripOrientationMetadata(self.imageMetadata)

        if let data = self.renderPhoto().imageWithMetadata(meta) {
            let activity = UIActivityViewController(activityItems: [data], applicationActivities: nil)

            activity.popoverPresentationController?.sourceView = self.view
            activity.popoverPresentationController?.sourceRect = self.saveBtn.frame
            activity.completionWithItemsHandler = { activity, completed, returnedItems, error in
                if activity == UIActivityTypeSaveToCameraRoll && completed {
                    self.savePhotoFeedback()
                }
            }
            self.presentViewController(activity, animated: true, completion: nil)
        }
    }

    func savePhotoFeedback() {
        let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .Alert)
        self.presentViewController(alert, animated: true, completion: { _ in
            delay(0.5) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })

    }

    func renderPhoto() -> UIImage {
        let source = self.sourcePhoto.rotateCameraImageToProperOrientation(CGFloat(MAXFLOAT))
        return self.imageForPreset(self.preset, useImage: source)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

//
//  NoirScaleHackViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit

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
    
    @IBAction func onTapShare() {
        let photo = self.renderPhoto()
        let activity = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        self.presentViewController(activity, animated: true, completion: nil)
    }
    
    func renderPhoto() -> UIImage {
        return self.imageForPreset(self.preset, useImage: self.sourcePhoto)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

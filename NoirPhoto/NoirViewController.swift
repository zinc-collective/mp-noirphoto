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

protocol ImageEditorInterfaceProvider: UIViewController {
    func pickPhoto(_ assetIdentifier: String, image: UIImage)
}


// scales up the whole view, just like if we weren't supporting iPhone 6 or 6+
class NoirViewController: NoirViewControllerLegacy {

    // SCALE HACK: remove me once we change the UI
    override func viewWillAppear(_ animated: Bool) {
        if (UI_USER_INTERFACE_IDIOM() == .phone) {
            let scale = self.view.frame.size.width / CGFloat(320)
            self.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            super.viewWillAppear(animated)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(NoirViewController.onSwipeGripDown))
        downGesture.direction = .down

        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(NoirViewController.onSwipeGripUp))
        upGesture.direction = .up

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
            
            // TODO: check for iPad compatability
            activity.popoverPresentationController?.sourceView = self.view
            activity.popoverPresentationController?.sourceRect = self.saveBtn.frame
            activity.completionWithItemsHandler = { activity, completed, returnedItems, error in
                if activity == UIActivity.ActivityType.saveToCameraRoll && completed {
                    self.savePhotoFeedback()
                }
            }
            self.present(activity, animated: true, completion: nil)
        }
    }

    func savePhotoFeedback() {
        let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            delay(0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        })

    }

    func renderPhoto() -> UIImage {
        let source = self.sourcePhoto.rotateCameraImageToProperOrientation(CGFloat(MAXFLOAT))
        return self.image(for: self.preset, use: source)
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

}


// MARK: - delegate ImageEditor
extension NoirViewController: ImageEditorInterfaceProvider {
    func pickPhoto(_ assetIdentifier: String, image: UIImage) {
        
        print("##-> loadImageMetadataFromPicTEST=\(image)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.initUsedPropertiesAndUI(forOriginPhoto: image)
            self.saveOriginPhoto(image)
        }
//        NSLog(@"##-> loadImageMetadataFromPicTEST=%@", [[self class] dictionaryWithImageMetadata: assetURL error:nil]);
//
//
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library assetForURL:assetURL
//                 resultBlock:^(ALAsset *asset)  {
//                     NSDictionary *metadata = asset.defaultRepresentation.metadata;
//
//                     //NSLog(@"metadata=, %@", metadata);
//
//                     //imageMetadata = nil;
//                     self.imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:metadata];
//                     //[self addEntriesFromDictionary:metadata];
//
//                    NSLog(@"##-> loadImageMetadataFromPic=%@", self.imageMetadata);
//                     NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//                     NSString *path=[paths    objectAtIndex:0];
//                     NSString *filename=[path stringByAppendingPathComponent:metadata_plist];
//
//                     [imageMetadata writeToFile:filename  atomically:YES];
//                 }
//                failureBlock:^(NSError *error) {
//                }];
    }
}

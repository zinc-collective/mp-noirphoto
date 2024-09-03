//
//  NoirScaleHackViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Photos


protocol ImageEditorInterfaceProvider: UIViewController {
    func pickPhoto(_ assetIdentifier: String, image: UIImage)
}


// scales up the whole view, just like if we weren't supporting iPhone 6 or 6+
class NoirViewController: NoirViewControllerLegacy {
    var logger: AppLogger?
    var imageProvider: PhotoProvider?
    weak var delegate : PhotoProviderDelegate?
    var viewController : ImageEditorInterfaceProvider?


    // SCALE HACK: remove me once we change the UI
    override func viewWillAppear(_ animated: Bool) {
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            let scale = self.view.frame.size.width / CGFloat(320)
            self.view.transform = CGAffineTransformMakeScale(scale, scale)
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
    
    #warning("### - need to verify the entire photo selection flow from splash screen & NoirVC")
    #warning("### - need to verify the iPad behavior")
    @IBAction func handleLibrary(_ sender: AnyObject) {
        print("LIBRARY NOIR")

        // Request photo access earlier so the photos window isn't black
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("AUTHORIZED NOIR")
            case .restricted:
                print("RESTRICTED NOIR")
            case .denied:
                print("DENIED NOIR")
            default:
                // place for .NotDetermined - in this callback status is already determined so should never get here
                break
            }

            DispatchQueue.main.async {
                self.openPicker()
            }
        }
    }
    
    func openPicker() {
        self.imageProvider?.getPhoto({ [weak self] image, assetIdentifier in
            guard let self = self,
                  let image = image,
                  let assetIdentifier = assetIdentifier else { return }
            self.delegate?.providerDidPickImage(UIImage(cgImage: image), assetIdentifier: assetIdentifier)
        })
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
        
        //TODO: - bring back image metadata - API hunt/rewrite will be required
        #warning("### - bring back image metadata")
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


// MARK: - delegate PhotoProviderDelegate
extension NoirViewController: PhotoProviderDelegate {
    func providerDidPickImage(_ image: UIImage, assetIdentifier: String) {
        self.pickPhoto(assetIdentifier, image: image)
    }
}

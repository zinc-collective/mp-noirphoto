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
import LinkPresentation

protocol ImageEditorInterfaceProvider: UIViewController {
    func pickPhoto(_ assetIdentifier: String, image: UIImage)
}


struct NoirConfiguration {
    var tintMaskImage: String
}


// scales up the whole view, just like if we weren't supporting iPhone 6 or 6+
class NoirViewController: NoirViewControllerLegacy {
    var newTintMaskView: UIImageView?
    var infoVC: (() -> UIViewController)?
    var logger: AppLogger?
    var imageProvider: PhotoProvider?
    weak var delegate : PhotoProviderDelegate?
    private var configuration: NoirConfiguration!
    
    convenience init(configuration: NoirConfiguration) {
        self.init()
        self.configuration = configuration
    }

    // SCALE HACK: remove me once we change the UI
    override func viewWillAppear(_ animated: Bool) {
        setUpImageViews()
        if (UIDevice.current.userInterfaceIdiom == .phone) {
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
        self.delegate = self
    }
    
    // MARK: - protocol UIContentContainer
    // Currently disabled via the orientation settings in the project settings
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            if (!UIScene.isLandscape) {
                print("### Portrait")
                self.applyPortraitConstraints()
                // Do something
            } else {
                print("### LandScape")
                // Do something else
                self.applyLandscapeConstraints()
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("### rotation completed")
        })
        
        super.viewWillTransition(to: size, with: coordinator)
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
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        
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
    
    @IBAction func infoAction(_ sender: AnyObject) {
        if let vc = self.infoVC?() {
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func handleInfo(_ sender: AnyObject) {
        print("INFO NOIR")
        guard let vc = self.infoVC?() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

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
}

extension NoirViewController: UIActivityItemSource {
    static let activityViewIconName = "activityViewIcon"
    
    private func getShareData() -> Data? {
        let meta = UIImage.stripOrientationMetadata(self.imageMetadata)

        if let data = self.renderPhoto().imageWithMetadata(meta) {
            return data
        } else { return nil }
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: Self.activityViewIconName)!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return self.getShareData()
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        // set the icon on the Activity Sheet
        // the imageProvider overrides the iconProvider
        let metadata            = LPLinkMetadata()
        metadata.title          = "Share your image from Noir Photo" // Preview Title
        metadata.imageProvider  = NSItemProvider(object: UIImage(named: Self.activityViewIconName)!)
//        metadata.iconProvider   = NSItemProvider(object: UIImage(systemName: "clock")!)
//        metadata.originalURL    = urlOfImageToShare // determines the Preview Subtitle
//        metadata.url            = urlOfImageToShare

        return metadata
    }
    
}

// MARK: Private Methods
private extension NoirViewController {
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
    
    func setUpImageViews() {
        // TODO: - should move btn initialization from legcay controller to here
        if let config = configuration {
//            self.newTintMaskView = UIImageView(image: UIImage(named: config.tintMaskImage))
        }
        if let tintView = self.newTintMaskView {
            self.view.addSubview(tintView)
            // default to Portrait layout
        }
        applyPortraitConstraints()
    }
    
    func applyPortraitConstraints() {
        let panelBottomOffsetRowTop = -74.0
        let panelBottomOffsetRowBottom = -18.0
        let panelTrailingOffsetRowTop = -20.0
        let panelTrailingOffsetRowBottom = -28.0
        let marginBetweenRows = -17.0
        self.infoBtn.translatesAutoresizingMaskIntoConstraints = false
        self.loadBtn.translatesAutoresizingMaskIntoConstraints = false
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoBtn.trailingAnchor.constraint(equalTo: self.ctrlPadView.trailingAnchor,
                                                   constant: panelTrailingOffsetRowBottom),
            self.infoBtn.bottomAnchor.constraint(equalTo: self.ctrlPadView.bottomAnchor,
                                                 constant: panelBottomOffsetRowBottom),
            self.saveBtn.trailingAnchor.constraint(equalTo: self.ctrlPadView.trailingAnchor,
                                                   constant: panelTrailingOffsetRowTop),
            self.saveBtn.bottomAnchor.constraint(equalTo: self.ctrlPadView.bottomAnchor,
                                                 constant: panelBottomOffsetRowTop),
            self.loadBtn.trailingAnchor.constraint(equalTo: self.saveBtn.leadingAnchor,
                                                   constant: marginBetweenRows),
            self.loadBtn.bottomAnchor.constraint(equalTo: self.ctrlPadView.bottomAnchor,
                                                 constant: panelBottomOffsetRowTop)
        ])
        
        if let tintView = self.newTintMaskView {
            tintView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                // Problem: iPad has different layout
                // problem: _ctrlPadView is not accessible in the view heirachy
                // problem: this will not work without a full re-do of the view's layout :(
//                tintView.trailingAnchor.constraint(equalTo: , constant: <#T##CGFloat#>)
            ])
        }
    }
    
    func applyLandscapeConstraints() {
        assertionFailure("Not yet implemented")
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


// MARK: - delegate SplashDelegate
extension NoirViewController: PhotoProviderDelegate {
    func providerDidPickImage(_ image: UIImage, assetIdentifier: String) {
        self.pickPhoto(assetIdentifier, image: image)
    }
}


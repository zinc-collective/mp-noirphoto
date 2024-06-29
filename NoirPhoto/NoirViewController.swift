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


struct NoirConfiguration {
    var tintMaskImage: String
}


// scales up the whole view, just like if we weren't supporting iPhone 6 or 6+
class NoirViewController: NoirViewControllerLegacy {
    enum NoirError: LocalizedError {
        case shareOperationFailed
        
        public var errorDescription: String? {
            switch self {
            case .shareOperationFailed:
                return NSLocalizedString(
                    "Unable to share item.",
                    comment: "Share operation failed"
                )
            }
        }
    }
    
    var newTintMaskView: UIImageView?
    var infoVC: (() -> UIViewController)?
    var logger: AppLogger?
    var imageProvider: PhotoProvider?
    weak var delegate : PhotoProviderDelegate?
    private var shareAgent: (any ShareableActivityProvider)?
    private var configuration: NoirConfiguration!
    private var ctrlPadConfig: ControlPadConfiguration!
    
    convenience init(configuration: NoirConfiguration,
                     shareAgent: (any ShareableActivityProvider)?,
                     ctrlPadConfig: ControlPadConfiguration) {
        self.init()
        self.shareAgent     = shareAgent
        self.configuration  = configuration
        self.ctrlPadConfig  = ctrlPadConfig
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
    
    @IBAction func onTapShare() {
        let completion: ShareableActivityProvider.ProviderCompletion = { [weak self] activity, completed, returnedItems, error in
            guard let self = self else { return }
            
            if completed {
                if activity == .saveToCameraRoll {
                    self.savePhotoFeedback()
                }
            } else {
                self.logger?.logError(NoirError.shareOperationFailed)
                self.logger?.logToConsole("Share Operation Failed",
                                          .debug,
                                          .shareService)
            }
            if let error = error {
                self.logger?.logError(error)
                self.logger?.logToConsole("Share Operation Error",
                                          .debug,
                                          .shareService)
            }
        }
        
        shareAgent?.shareItem(sender: self,
                              sourceRect: self.saveBtn.frame,
                              data: getShareData(),
                              title: "Share your image from Noir Photo",
                              subtitle: nil, 
                              completion: completion)
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


// MARK: Private Methods
private extension NoirViewController {
    func getShareData() -> Data? {
        let meta = UIImage.stripOrientationMetadata(self.imageMetadata ?? [:])

        if let data = self.renderPhoto().imageWithMetadata(meta) {
            return data
        } else { return nil }
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
        applyPortraitConstraintsForControlPadView()
        // MUST set constraints for ControlPadVIew BEFORE buttons
        applyPortraitConstraintsForControlButtons()
        applyPortraitConstraintsForTintMaskView()
    }
    
    func applyLandscapeConstraints() {
        assertionFailure("Not yet implemented")
    }
    
    func applyPortraitConstraintsForControlPadView() {
        self.view.layoutIfNeeded()
        if let ctrlPadView = self.ctrlPadView {
            let calculatedHeight        = Self.Constants.iPadLegacyRatio * self.view.bounds.width
            ctrlPadView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                ctrlPadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20.0),
                ctrlPadView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ctrlPadView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ctrlPadView.heightAnchor.constraint(equalToConstant: calculatedHeight)
            ])
            ctrlPadView.setupConstraintsForBackgroundView()
            ctrlPadView.setupConstraintsForTintsView()
            ctrlPadView.setupConstraintsForAdjustView()
            ctrlPadView.setupConstraintsForPresetsView()
        }
    }
    
    func applyPortraitConstraintsForControlButtons() {
        // MUST set constraints for ControlPadVIew BEFORE buttons
        self.view.layoutIfNeeded()
        let newWidth: CGFloat                       = self.ctrlPadView.frame.size.width
        let newHeight: CGFloat                      = self.ctrlPadView.frame.size.height
        let calculatedPanelBottomOffsetRowTop       = (self.ctrlPadConfig.btnPosition.panelBottomOffsetRowTop / self.ctrlPadConfig.frame.height) * newHeight
        let calculatedPanelBottomOffsetRowBottom    = (self.ctrlPadConfig.btnPosition.panelBottomOffsetRowBottom / self.ctrlPadConfig.frame.height) * newHeight
        let calculatedPanelTrailingOffsetRowTop     = (self.ctrlPadConfig.btnPosition.panelTrailingOffsetRowTop / self.ctrlPadConfig.frame.width) * newWidth
        let calculatedPanelTrailingOffsetRowBottom  = (self.ctrlPadConfig.btnPosition.panelTrailingOffsetRowBottom / self.ctrlPadConfig.frame.width) * newWidth
        let calculatedMarginBetweenRows             = (self.ctrlPadConfig.btnPosition.marginBetweenRows / self.ctrlPadConfig.frame.width) * newWidth
        let fullBtnOffset: CGFloat                   = 5.0
        let fullBtnSide: CGFloat                     = ControlPadView.Frames.fullBtnRect.width
        self.infoBtn.translatesAutoresizingMaskIntoConstraints = false
        self.loadBtn.translatesAutoresizingMaskIntoConstraints = false
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = false
        self.fullBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoBtn.trailingAnchor.constraint(equalTo: self.ctrlPadView.trailingAnchor,
                                                   constant: -calculatedPanelTrailingOffsetRowBottom),
            self.infoBtn.bottomAnchor.constraint(equalTo: self.ctrlPadView.bottomAnchor,
                                                 constant: -calculatedPanelBottomOffsetRowBottom),
            self.saveBtn.trailingAnchor.constraint(equalTo: self.ctrlPadView.trailingAnchor,
                                                   constant: -calculatedPanelTrailingOffsetRowTop),
            self.saveBtn.bottomAnchor.constraint(equalTo: self.ctrlPadView.bottomAnchor,
                                                 constant: -calculatedPanelBottomOffsetRowTop),
            self.loadBtn.trailingAnchor.constraint(equalTo: self.saveBtn.leadingAnchor,
                                                   constant: -calculatedMarginBetweenRows),
            self.loadBtn.bottomAnchor.constraint(equalTo: self.ctrlPadView.bottomAnchor,
                                                 constant: -calculatedPanelBottomOffsetRowTop),
            self.fullBtn.widthAnchor.constraint(equalToConstant: fullBtnSide),
            self.fullBtn.heightAnchor.constraint(equalToConstant: fullBtnSide),
            self.fullBtn.topAnchor.constraint(equalTo: self.ctrlPadView.topAnchor, constant: fullBtnOffset),
            self.fullBtn.trailingAnchor.constraint(equalTo: self.ctrlPadView.trailingAnchor, constant: -fullBtnOffset)
        ])
    }
    
    func applyPortraitConstraintsForTintMaskView() {
        self.view.layoutIfNeeded()
        if let tintView = self.newTintMaskView {
//            tintView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                // Problem: iPad has different layout
                // problem: _ctrlPadView is not accessible in the view heirachy
                // problem: this will not work without a full re-do of the view's layout :(
//                tintView.trailingAnchor.constraint(equalTo: , constant: <#T##CGFloat#>)
            ])
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


extension NoirViewController {
    enum Constants {
        static let ctrlPadeViewBottomOffset         = 20.0
        static let iPhoneLegacyHeight               = 480.0
        static let iPhoneLegacyWidth                = 320.0
        static let ctrlPadHead                      = 50.0
        static let iPhoneLegacyRatio                = Self.iPhoneLegacyWidth/(Self.iPhoneLegacyHeight-Self.ctrlPadHead)
        static let iPadLegacyHeight                 = 256.0
        static let iPadLegacyWidth                  = 768.0
        static let iPadLegacyRatio                  = Self.iPadLegacyHeight/Self.iPadLegacyWidth
    }
    
    enum RConfigConstants {
        static let presetsPlistCurrent         = "Presets_current.pList"
        static let presetsPlistDefault         = "Presets_default.pList"
    }
}

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
    var logger: AppLogger?
    var infoVC: (() -> UIViewController)?
    var imageProvider: PhotoProvider?
    weak var delegate : PhotoProviderDelegate?
    var viewController : ImageEditorInterfaceProvider?
    private var shareAgent: (any ShareableActivityProvider)?
    private var shareCompletion: ShareableActivityProvider.ProviderCompletion?
    
    convenience init(nibName: String?,
                     bundle: Bundle?,
                     shareAgent: (any ShareableActivityProvider)?,
                     shareCompletion: ShareableActivityProvider.ProviderCompletion? = nil) {
        self.init(nibName: nibName, bundle: bundle)
        self.shareAgent = shareAgent
        self.shareCompletion = shareCompletion
    }
    
    
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
        let completion: ShareableActivityProvider.ProviderCompletion = self.shareCompletion ?? { [weak self] activity, completed, returnedItems, error in
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
    
    @IBAction func handleInfo(_ sender: AnyObject) {
        print("INFO NOIR")
        guard let vc = self.infoVC?() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
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

    // TODO: render after share like in Plastic Bullet? Or in the background?
    func renderPhoto() -> UIImage {
        let source = self.sourcePhoto.rotateCameraImageToProperOrientation(CGFloat(MAXFLOAT))
        return self.image(for: self.preset, use: source)
    }
    
    func openPicker() {
        self.imageProvider?.getPhoto({ [weak self] image, assetIdentifier in
            guard let self = self,
                  let image = image,
                  let assetIdentifier = assetIdentifier else { return }
            self.delegate?.providerDidPickImage(UIImage(cgImage: image), assetIdentifier: assetIdentifier)
        })
    }
    
    // MARK: Metadata helpers
    func metadataFilePath() -> String? {
        let path: String? = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return path?.appending("metadata_plist")
    }
    
    func writeMetadataToFile(_ metadata: NSDictionary) {
        if let filename = metadataFilePath() {
            // write to filename
            do {
               try metadata.write(to: URL(fileURLWithPath: filename))
            } catch {
                print("### -> METADATA WRITE TO FILE FAILED. this shoould be logged")
            }
        } else {
            print("### -> metadata write failed. FILE PATH NOT FOUND.  this shoould be logged")
        }
    }
    
    func readMetadataFromFile() -> NSMutableDictionary? {
        var metadata: NSMutableDictionary?
        if let filename = metadataFilePath(),
           FileManager.default.fileExists(atPath: filename) {
            metadata = NSMutableDictionary.init(contentsOf: URL(fileURLWithPath: filename))
            print("### --> helper --> loadImageMetadataFromDoc=%@\(metadata)")
        }
        return metadata
    }
}


// MARK: - delegate ImageEditor
extension NoirViewController: ImageEditorInterfaceProvider {
    func pickPhoto(_ assetIdentifier: String, image: UIImage) {
        // stop timers
        _vignetteFullView?.stopTimer()
        _vignetteView?.stopTimer()
        
        print("##-> loadImageMetadataFromPicTEST=\(image)")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.initUsedPropertiesAndUI(forOriginPhoto: image)
            self.saveOriginPhoto(image)
        }
        
        //TODO: - simplify image metadata - API hunt/rewrite will be required
        #warning("### - simplify image metadata")
        if let metadata = imageProvider?.getMetaData(assetIdentifier: assetIdentifier) {
            self.imageMetadata = NSMutableDictionary(dictionary: metadata)
            self.writeMetadataToFile(metadata)
        }
    }
}


// MARK: - delegate PhotoProviderDelegate
extension NoirViewController: PhotoProviderDelegate {
    func providerDidPickImage(_ image: UIImage, assetIdentifier: String) {
        self.pickPhoto(assetIdentifier, image: image)
    }
}

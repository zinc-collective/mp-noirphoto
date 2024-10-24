//
//  SplashViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/24/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Photos


class SplashViewController: UIViewController {

    var logger: AppLogger?
    var infoVC: (() -> UIViewController)?
    var imageProvider: PhotoProvider?
    weak var delegate : PhotoProviderDelegate?
    var viewController : ImageEditorInterfaceProvider?
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    @IBAction func handleInfo(sender: AnyObject) {
        self.logger?.logToConsole("INFO", .info, .splashVC)
        guard let vc = self.infoVC?() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func handleLibrary(_ sender: AnyObject) {
        self.logger?.logToConsole("LIBRARY", .info, .splashVC)
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                print("AUTHORIZED")
            case .restricted:
                print("RESTRICTED")
            case .denied:
                print("DENIED")
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


// MARK: - delegate PhotoProviderDelegate
extension SplashViewController: PhotoProviderDelegate {
    func providerDidPickImage(_ image: UIImage, assetIdentifier: String) {
        // this must go last (refactor needed)
        guard let vc = self.viewController else { return }
        self.navigationController?.setViewControllers([vc], animated: true)
        // Ensure the legacy controller superclass initializes before calling delegate method.
        // I would prefer to depend on a lifecycle callback but that will require a much larger refactor to do it cleanly.
        _ = vc.view
        vc.pickPhoto(assetIdentifier, image: image)
    }
}


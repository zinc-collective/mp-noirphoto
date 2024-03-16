//
//  SplashViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/24/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import Photos
import Sentry

protocol SplashDelegate : AnyObject {
    func splashDidPickImage(_ image: UIImage, assetIdentifier: String)
}


class SplashViewController: UIViewController {

    var logger: AppLogger?
    var imageProvider: PhotoProvider?
    var viewController : ImageEditorInterfaceProvider?
    weak var delegate : SplashDelegate?
    
    override func viewDidLoad() {
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }

    @IBAction func handleInfo(_ sender: AnyObject) {
        print("INFO")
        let sb = UIStoryboard(name: "Info", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func handleLibrary(_ sender: AnyObject) {
        print("LIBRARY")

        // Request photo access earlier so the photos window isn't black
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
        // hand picked origin to line up with ipad. This is ignored for iphone
        // the splash screen uses full-screen button sizes
        let buttonSize = CGSize(width: 40, height: 40) // size of the image
        let buttonOrigin = CGPoint(x: view.frame.size.width - buttonSize.width - 76, y: view.frame.size.height - buttonSize.height - 80)
        self.imageProvider?.getPhoto({ [weak self] image, assetIdentifier in
            guard let self = self,
                  let image = image,
                  let assetIdentifier = assetIdentifier else { return }
            self.delegate?.splashDidPickImage(UIImage(cgImage: image), assetIdentifier: assetIdentifier)
        })
    }
}


// MARK: - delegate SplashDelegate
extension SplashViewController: SplashDelegate {
    func splashDidPickImage(_ image: UIImage, assetIdentifier: String) {
        // this must go last (refactor needed)
        guard let vc = self.viewController else { return }
        self.navigationController?.setViewControllers([vc], animated: true)
        vc.pickPhoto(assetIdentifier, image: image)
    }
}

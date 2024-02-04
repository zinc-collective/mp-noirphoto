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

protocol SplashDelegate : class {
    func splashDidPickImage(_ image: UIImage, url: URL)
}

class SplashViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var logger: AppLogger?
    var imagePicker : UIImagePickerController?
    weak var delegate : SplashDelegate?

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
        print("OPEN PICKER")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.modalPresentationStyle = .popover

        // hand picked origin to line up with ipad. This is ignored for iphone
        // the splash screen uses full-screen button sizes
        let buttonSize = CGSize(width: 40, height: 40) // size of the image
        let buttonOrigin = CGPoint(x: view.frame.size.width - buttonSize.width - 76, y: view.frame.size.height - buttonSize.height - 80)

        picker.popoverPresentationController?.sourceView = self.view
        picker.popoverPresentationController?.sourceRect = CGRect(origin: buttonOrigin, size: buttonSize)

        self.present(picker, animated: true, completion: nil)

        self.imagePicker = picker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        //logging
        let msg0 = "Picked Image \(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.referenceURL)])"
        let msg1 = "  info = \(info)"
        logger?.logToConsole("PICKED IMAGE", .debug, .splashVC)
        logger?.logToConsole(msg0, .debug, .splashVC)
        logger?.logToConsole(msg1, .info, .splashVC)

        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage

        // if it isn't there, then
        let assetURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.referenceURL)] as! URL
        // I can't display it myself, need to pass it back

        self.imagePicker?.dismiss(animated: true, completion: nil)
        self.delegate?.splashDidPickImage(image, url: assetURL)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

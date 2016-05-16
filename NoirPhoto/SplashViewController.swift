//
//  SplashViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/24/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit
import Photos
import Crashlytics

protocol SplashDelegate : class {
    func splashDidPickImage(image: UIImage, url: NSURL)
}

class SplashViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker : UIImagePickerController?
    weak var delegate : SplashDelegate?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    @IBAction func handleInfo(sender: AnyObject) {
        print("INFO")
        let sb = UIStoryboard(name: "Info", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("InfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleLibrary(sender: AnyObject) {
        print("LIBRARY")
        
        // Request photo access earlier so the photos window isn't black
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .Authorized:
                print("AUTHORIZED")
            case .Restricted:
                print("RESTRICTED")
            case .Denied:
                print("DENIED")
            default:
                // place for .NotDetermined - in this callback status is already determined so should never get here
                break
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.openPicker()
            }
        }
    }
    
    func openPicker() {
        print("OPEN PICKER")
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        picker.modalPresentationStyle = .Popover
        
        // hand picked origin to line up with ipad. This is ignored for iphone
        // the splash screen uses full-screen button sizes
        let buttonSize = CGSize(width: 40, height: 40) // size of the image
        let buttonOrigin = CGPoint(x: view.frame.size.width - buttonSize.width - 76, y: view.frame.size.height - buttonSize.height - 80)
        
        picker.popoverPresentationController?.sourceView = self.view
        picker.popoverPresentationController?.sourceRect = CGRect(origin: buttonOrigin, size: buttonSize)
        
        self.presentViewController(picker, animated: true, completion: nil)
        
        self.imagePicker = picker
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("PICKED IMAGE")
        
        CrashlyticsBridge.log("Picked Image \(info[UIImagePickerControllerReferenceURL])")
        CrashlyticsBridge.log("  info = \(info)")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // if it isn't there, then
        let assetURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        // I can't display it myself, need to pass it back
        
        self.imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.splashDidPickImage(image, url: assetURL)
    }
}

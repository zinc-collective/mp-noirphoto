//
//  SplashViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/24/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit

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
        return true
    }
    
    @IBAction func handleInfo(sender: AnyObject) {
        print("INFO")
        let sb = UIStoryboard(name: "Info", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("InfoViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleLibrary(sender: AnyObject) {
        print("LIBRARY")
        let picker = UIImagePickerController()
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
        
        self.imagePicker = picker
    }
    
    @IBAction func unwindToSplash() {
        print("SPLASH")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("PICKED IMAGE")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let assetURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        // I can't display it myself, need to pass it back
        
        self.imagePicker?.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.splashDidPickImage(image, url: assetURL)
    }
}

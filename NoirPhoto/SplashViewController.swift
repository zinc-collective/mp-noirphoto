//
//  SplashViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/24/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
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
    }
    
    @IBAction func unwindToSplash() {
        print("SPLASH")
    }
}

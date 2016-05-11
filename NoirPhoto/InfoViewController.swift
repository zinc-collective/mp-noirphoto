//
//  InfoViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.backgroundColor = UIColor.clearColor()
        webView.opaque = false
        webView.scrollView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self
        
        if let url = NSBundle.mainBundle().URLForResource("info", withExtension: "html"), path = url.path {
        
            do {
                let string = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
                webView.loadHTMLString(string, baseURL: nil)
            }
            catch let err as NSError {
                print("Web View Error: ", err.description)
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.URL where navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(url)
            return false
        }
        
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func handleBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

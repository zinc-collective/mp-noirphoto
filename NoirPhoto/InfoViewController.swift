//
//  InfoViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {


    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.delegate = self

        if let url = Bundle.main.url(forResource: "info", withExtension: "html"){
            
            do {
                // let path = url.path was formerly part of the if/let logic check above
                let path = url.path
                let string = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
                webView.loadHTMLString(string, baseURL: nil)
            }
            catch let err as NSError {
                print("Web View Error: ", err.description)
            }
        }
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        if let url = request.url, navigationType == .linkClicked {
            UIApplication.shared.openURL(url)
            return false
        }

        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

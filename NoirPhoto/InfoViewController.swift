//
//  InfoViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class InfoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
//    let linkColor = UIColor(red: 0.827, green: 0.392, blue: 0.2235, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let image = UIImage(named: "InfoText")!
//        let imageView = UIImageView(image: image)
//        let heightToWidth = image.size.height / image.size.width
//        let width = view.frame.size.width
//        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width * heightToWidth)
//        self.scrollView.contentSize = imageView.frame.size
//        self.scrollView.addSubview(imageView)
        
        textView.dataDetectorTypes = .All
        textView.delegate = self
        textView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
//        textView.linkTextAttributes = [NSForegroundColorAttributeName: redColor]
        
        if let text = loadMD("info-text") {
            text.body.color = UIColor.whiteColor()
//            text.link.color = UIColor.greenColor() //
            
            textView.attributedText = text.attributedString()
        }
    }
    
    
    func loadMD(name:String) -> SwiftyMarkdown? {
        if let url = NSBundle.mainBundle().URLForResource(name, withExtension: "md") {
            return SwiftyMarkdown(url: url)
        }
        return nil
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
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

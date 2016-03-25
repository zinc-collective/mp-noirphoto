//
//  InfoViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2016 Moment Park. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "InfoText")!
        let imageView = UIImageView(image: image)
        let heightToWidth = image.size.height / image.size.width
        let width = view.frame.size.width
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width * heightToWidth)
        self.scrollView.contentSize = imageView.frame.size
        self.scrollView.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func handleBack() {
        print("BACK")
        self.navigationController?.popViewControllerAnimated(true)
    }
}

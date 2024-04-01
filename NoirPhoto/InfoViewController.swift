//
//  InfoViewController.swift
//  NoirPhoto
//
//  Created by Sean Hess on 3/25/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import UIKit
import WebKit


struct InfoConfiguration {
    var buttonLeftMarginValue: Double
    var buttonTopMarginValue: Double
    var buttonSideValue: Double
    var scrollViewInsetSize: Double
    var defaultFontSize: Double
}

class InfoViewController: UIViewController {
    private var wrapperView: UIView?
    private var wkWebView: WKWebView?
    private var backgroundImage: UIImageView?
    private var button: UIButton?
    private var configuration: InfoConfiguration!
    
    convenience init(configuration: InfoConfiguration) {
        self.init()
        self.configuration = configuration
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }

    @objc func handleBack() {
        self.wkWebView?.reload()
        self.navigationController?.popViewController(animated: true)
    }
}


private extension InfoViewController {
    func loadContent() {
        if let url = Bundle.main.url(forResource: "info", withExtension: "html"),
           let webView = self.wkWebView {
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
            setFontSize(webView: webView, size: configuration.defaultFontSize)
        }
    }
    
    func setFontSize(webView: WKWebView, size: Double) {
        let fontSizeString = "\(size)px"
        let injection = """
        var style = document.createElement('style');
        style.innerHTML = 'body * { font-size: \(fontSizeString); }';
        document.head.appendChild(style);
        """
        let script = WKUserScript(source: injection, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
        webView.evaluateJavaScript(injection, completionHandler: nil)
    }
    
    func buildWebWrapperView() {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        self.wrapperView = view
    }
    
    func buildWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.contentInset = .zero
        webView.scrollView.clipsToBounds = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.insetsLayoutMarginsFromSafeArea = true
        
        self.wkWebView = webView
    }
    
    func setupConstraintForWrapperView() {
        guard let wrapper = self.wrapperView else { return }
        
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: self.view.topAnchor),
            wrapper.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            wrapper.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            wrapper.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setupConstraintForWebView() {
        guard let webView = self.wkWebView,
              let superview = self.wrapperView else { return }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: superview.topAnchor),
            webView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: configuration.scrollViewInsetSize),
            webView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -configuration.scrollViewInsetSize)
        ])
    }
    
    func buildBackgroundImageView() {
        let img = UIImage(named: "InfoBackground")
        let bgdView = UIImageView(image: img)
        self.backgroundImage = bgdView
    }
    
    func setupConstraintForBackgroundImageView() {
        guard let bgdView = self.backgroundImage else { return }
        
        bgdView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgdView.topAnchor.constraint(equalTo: self.view.topAnchor),
            bgdView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bgdView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bgdView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func buildButton() {
        self.button = UIButton(frame: CGRectZero)
        button?.setImage(UIImage(named: "InfoBack"), for: .normal)
        button?.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    func setupConstraintForButton() {
        guard let button = self.button else { return }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: configuration.buttonTopMarginValue),
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: configuration.buttonLeftMarginValue),
            button.widthAnchor.constraint(equalToConstant: configuration.buttonSideValue),
            button.heightAnchor.constraint(equalToConstant: configuration.buttonSideValue)
        ])
    }
    
    func setupConstraintForMainView() {
        guard let view = self.view,
              let superview = view.superview else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
    
    func setup() {
        buildWebWrapperView()
        buildWebView()
        buildBackgroundImageView()
        buildButton()
        
        if let webView = self.wkWebView,
           let backgroundImage = self.backgroundImage,
           let button = self.button,
           let wrapper = self.wrapperView {
            self.view.addSubview(backgroundImage)
            self.view.addSubview(wrapper)
            wrapper.addSubview(webView)
            self.view.addSubview(button)
            
            webView.navigationDelegate = self
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        setupConstraintForMainView()
        setupConstraintForBackgroundImageView()
        setupConstraintForWrapperView()
        setupConstraintForWebView()
        setupConstraintForButton()
    }
}


extension InfoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            webView.configuration.userContentController.removeAllUserScripts()
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}

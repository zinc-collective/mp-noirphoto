//
//  VerticalPickerView.swift
//  NoirPhoto
//
//  Created by Cricket on 7/14/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import UIKit


@objc class VerticalPickerView: UIView {
    
    lazy var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var contentView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        return view
    }()
    
//    lazy var adjustMaskView: UIImageView = {
//        var maskName: String = UIDevice.current.userInterfaceIdiom == .pad ? "adjust_mask-iPad.png" : "adjust_mask.png"
//        var view = UIImageView(image: UIImage(named: maskName))
//        view.isUserInteractionEnabled = false
//        return view
//    }()
    
    @objc public var delegate: CustomPickerDelegate?
        
    var image: UIImage?
    var topOffset: Float?
    var btmOffset: Float?
    
    var minValue: Float?
    var maxValue: Float?
    @objc public var defaultValue: CGFloat = 0.0
    
//    convenience init(frame: CGRect, image: UIImage, topOffset: Float, btmOffset: Float, defaultValue: Float) {
////        self.init(frame: frame)
//        self.init()
//        self.topOffset = topOffset
//        self.btmOffset = btmOffset
//        self.defaultValue = defaultValue
//    }
    
    @objc func setImage(_ image: UIImage) {
        self.image = image
        self.contentView.image = image
    }
    
    @objc func setParameters(_ minValue: Float, maxValue: Float, useHeight: Float, useOffset: Float) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = 0.0
    }
    
    @objc func setParameters(_ minValue: Float, maxValue: Float, defaultValue: CGFloat) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
    }
    
    @objc func setTheCurrentValue(_ value: Float) {
        
    }
    
    @objc func pickTheCurrentValue(_ bFinalPick: Bool) {
        
    }
    
    @objc func setLayoutContraintsForScroll() {
        let originalImaageRatio: CGFloat = 395.0 / 66.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: originalImaageRatio),
            contentView.widthAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor, multiplier: originalImaageRatio),
            contentView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
        ])
    }
    
    @objc func startVerticalPickerView() {
//        setLayoutContraintsForScrollView()
        setupScrollView()
        setupViews()
    }
}

private extension VerticalPickerView {
    func setupScrollView(){
        let originalImaageRatio: CGFloat = 395.0 / 66.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: originalImaageRatio),
            contentView.widthAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor, multiplier: originalImaageRatio),
            contentView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
        ])
    }
    
    func setupViews(){
//        contentView.addSubview(label1)
//        label1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        label1.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        label1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
//
//        contentView.addSubview(label2)
//        label2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 25).isActive = true
//        label2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
//        label2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}


extension VerticalPickerView: UIScrollViewDelegate {

}
//
//extension VerticalPickerView: RScrollViewDelegate {
//
//}

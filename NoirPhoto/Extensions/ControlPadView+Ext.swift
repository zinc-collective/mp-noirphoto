//
//  ControlPadView+Ext.swift
//  NoirPhoto
//
//  Created by Cricket on 6/10/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation


struct ControlPadConfiguration {
    var frame: CGRect
    var resetButtonRect: CGRect
    var presetsConfig: PresetsConfiguration
    var tintsConfig: TintsConfiguration
    var adjustsConfig: AdjustConfiguration
    var primaryBtnConfig: ButtonConfiguration
    var secondaryBtnConfig: ButtonConfiguration
    var auxBtnConfig: ButtonConfiguration
    var imageName: String
    var btnPosition: ButtonPositionConfiguration
}

struct PresetsConfiguration {
    var frame: CGRect
    var buttonSize: CGSize
}

struct TintsConfiguration {
    var frame: CGRect
    var buttonSize: CGSize
}

struct AdjustConfiguration {
    var frame: CGRect
}

struct ButtonConfiguration {
    var frame: CGRect
    var imageName: String
}

struct ButtonPositionConfiguration {
    var panelBottomOffsetRowTop: CGFloat
    var panelBottomOffsetRowBottom: CGFloat
    var panelTrailingOffsetRowTop: CGFloat
    var panelTrailingOffsetRowBottom: CGFloat
    var marginBetweenRows: CGFloat
}


extension ControlPadView {
    enum Constants {
        static let legacyHeight                     = 256.0
        static let legacyWidth                      = 768.0
        static let legacyRatio                      = Self.legacyHeight/Self.legacyWidth
        static let panelBottomOffsetRowTop          = -74.0
        static let panelBottomOffsetRowBottom       = -20.0
        static let panelTrailingOffsetRowTop        = -21.0
        static let panelTrailingOffsetRowBottom     = -29.0
        static let marginBetweenRows                = -20.0
        static let loadBtnHeightRatio               = Self.panelBottomOffsetRowTop/Self.legacyHeight
        static let loadBtnWidthRatio                = Self.marginBetweenRows/Self.legacyWidth
        static let saveBtnHeightRatio               = Self.panelBottomOffsetRowTop/Self.legacyHeight
        static let saveBtnWidthRatio                = Self.panelTrailingOffsetRowTop/Self.legacyWidth
        static let infoBtnHeightRatio               = Self.panelBottomOffsetRowBottom/Self.legacyHeight
        static let infoBtnWidthRatio                = Self.panelTrailingOffsetRowBottom/Self.legacyWidth
    }
    
    // probably do not need these with autolayout
    enum Frames {
        static let resetBtnRectIPad = CGRect(x: 280.0, y: 20.0, width: 30.0, height: 30.0)
        static let resetBtnRect = CGRect(x: 280.0, y: 20.0, width: 30.0, height: 30.0)
        static let presetsRectIPad = CGRect(x: 267.0, y: 43.0, width: 488.0, height: 80.0)
        static let presetsRect = CGRect(x: 25.0, y: 5.0, width: 270.0, height: 32.0)
        static let presetsRect2 = CGRect(x: 10.0, y: 5.0, width: 270.0, height: 32.0)
        static let tintsRectIPad = CGRect(x: 270.0, y: 157.0, width: 368.0, height: 85.0)
        static let tintsRect = CGRect(x: 202.0, y: 65.0, width: 103.0, height: 103.0)
        static let adjustsRectIPad = CGRect(x: 26.0, y: 53, width: 224.0, height: 183.0)
        static let adjustsRect = CGRect(x: 0.0, y: 0.0, width: 164.0, height: 153.0)
        static let fullBtnRect = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    }
    
    @objc func setupConstraintsForBackgroundView() {
        if let bgView = self.bgView {
            bgView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bgView.topAnchor.constraint(equalTo: self.topAnchor),
                bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    @objc func setupConstraintsForAdjustView() {
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            setupConstraintsForIPadAdjustView()
        } else {
            setupConstraintsForIPhoneAdjustView()
        }
    }
    
    @objc func setupConstraintsForTintsView() {
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            setupConstraintsForIPadTintsView()
        } else {
            setupConstraintsForIPhoneTintsView()
        }
    }
    
    @objc func setupConstraintsForPresetsView() {
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            setupConstraintsForIPadPresetsView()
        } else {
            setupConstraintsForIPhonePresetsView()
        }
    }
    
    @objc func setupConstraintsForButtons() {
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            setupConstraintsForIPhoneButtons()
        } else {
            setupConstraintsForIPadButtons()
        }
    }
    
    @objc func setupConstraintsForIPhoneAdjustView() {}
    @objc func setupConstraintsForIPadAdjustView() {
        self.layoutIfNeeded()
        // iPad numbers
        let adjustLeadingMargin: CGFloat        = 24.0
        let adjustBottomMargin: CGFloat         = 20.0
        let newWidth: CGFloat                   = self.frame.size.width
        let newHeight: CGFloat                  = self.frame.size.height
        let calculatedLeadingMargin: CGFloat    = (adjustLeadingMargin/NoirViewController.Constants.iPadLegacyWidth) * newWidth
        let calculatedBottomMargin: CGFloat     = (adjustBottomMargin/NoirViewController.Constants.iPadLegacyHeight) * newHeight
        let calculatedIPadWidth                 = (Self.Frames.adjustsRectIPad.width/NoirViewController.Constants.iPadLegacyWidth) * newWidth
        let calculatedIPadHeight                = (Self.Frames.adjustsRectIPad.height/NoirViewController.Constants.iPadLegacyHeight) * newHeight
        
        if let adjustView = self.adjustView {
            adjustView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                adjustView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: calculatedLeadingMargin),
                adjustView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -calculatedBottomMargin),
                adjustView.heightAnchor.constraint(equalToConstant: calculatedIPadHeight),
                adjustView.widthAnchor.constraint(equalToConstant: calculatedIPadWidth)
            ])
            adjustView.setupConstraintsForPickerViews()
        }
    }
    
    @objc func setupConstraintsForIPhoneTintsView() {}
    @objc func setupConstraintsForIPadTintsView() {
        self.layoutIfNeeded()
        // iPad numbers
        let tintsLeadingMargin: CGFloat         = 24.0
        let tintsBottomMargin: CGFloat          = 6.75 * UIScreen.main.scale
        let newWidth: CGFloat                   = self.frame.size.width
        let newHeight: CGFloat                  = self.frame.size.height
        let calculatedLeadingMargin: CGFloat    = (tintsLeadingMargin/NoirViewController.Constants.iPadLegacyWidth) * newWidth
        let calculatedWidth: CGFloat            = ( Self.Frames.tintsRectIPad.width/NoirViewController.Constants.iPhoneLegacyHeight) * newWidth
        let calculatedHeight: CGFloat           = ( Self.Frames.tintsRectIPad.height/NoirViewController.Constants.iPadLegacyHeight) * newHeight

        if let tintsView = self.tintsView {
            tintsView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                tintsView.bottomAnchor.constraint(equalTo: self.adjustView.bottomAnchor, constant: tintsBottomMargin),
                tintsView.leadingAnchor.constraint(equalTo: self.adjustView.trailingAnchor, constant: calculatedLeadingMargin),
                tintsView.heightAnchor.constraint(equalToConstant: calculatedHeight),
                tintsView.widthAnchor.constraint(equalToConstant: calculatedWidth)
            ])
        }
    }
    
    @objc func setupConstraintsForIPhonePresetsView() {}
    @objc func setupConstraintsForIPadPresetsView() {
        self.layoutIfNeeded()
        // iPad numbers
//        let prestsLeadingMargin: CGFloat    = 40.0 * UIScreen.main.scale
        let prestsLeadingMargin: CGFloat        = 24.0
        let prestsTopMargin: CGFloat            = 4.0 * UIScreen.main.scale
        let newWidth: CGFloat                   = self.frame.size.width
        let newHeight: CGFloat                  = self.frame.size.height
        let calculatedLeadingMargin: CGFloat    = (prestsLeadingMargin/NoirViewController.Constants.iPadLegacyWidth) * newWidth
        let calculatedWidth: CGFloat            = ( Self.Frames.presetsRectIPad.width/NoirViewController.Constants.iPhoneLegacyHeight) * newWidth
        let calculatedHeight: CGFloat           = ( Self.Frames.presetsRectIPad.height/NoirViewController.Constants.iPadLegacyHeight) * newHeight

        if let prestsView = self.prestsView {
            prestsView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                prestsView.topAnchor.constraint(equalTo: self.adjustView.topAnchor, constant: -prestsTopMargin),
                prestsView.leadingAnchor.constraint(equalTo: self.adjustView.trailingAnchor, constant: calculatedLeadingMargin),
                prestsView.heightAnchor.constraint(equalToConstant: calculatedHeight),
                prestsView.widthAnchor.constraint(equalToConstant: calculatedWidth)
            ])
        }
    }
    
    func setupConstraintsForIPhoneButtons() {}
    func setupConstraintsForIPadButtons() {
        
    }
}

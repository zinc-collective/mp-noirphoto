//
//  AdjustView+Ext.swift
//  NoirPhoto
//
//  Created by Cricket on 6/16/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation


extension AdjustView {
    enum Frames {
        static let pickerWidthiPhone: CGFloat               = 49.0
        static let pickerWidthIpad: CGFloat                 = 66.0
    }
    
    @objc func setupConstraintsForPickerViews() {
        self.layoutIfNeeded()
        
        let pickerLeadingOffset: CGFloat            = 2.0
        let pickerSpacingIpad: CGFloat              = 9.0
        let newWidth: CGFloat                       = self.frame.size.width - pickerLeadingOffset
        let numberOfPickers: Int32                  = 3
        let calculatedPickerSapcing: CGFloat        = (pickerSpacingIpad / ControlPadView.Frames.adjustsRectIPad.width) * newWidth
        let calculatedPickerWidth: CGFloat          = (newWidth - (CGFloat((numberOfPickers-1)) * calculatedPickerSapcing)) / CGFloat(numberOfPickers)
        
        if let outsidePicker = self.expOutsidePicker,
           let insidePicker = self.expInsidePicker,
           let contrastPicker = self.expContrastPicker,
           let mask = self.adjustMaskView {
            outsidePicker.translatesAutoresizingMaskIntoConstraints = false
            insidePicker.translatesAutoresizingMaskIntoConstraints = false
            contrastPicker.translatesAutoresizingMaskIntoConstraints = false
            mask.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                outsidePicker.widthAnchor.constraint(equalToConstant: calculatedPickerWidth),
                outsidePicker.topAnchor.constraint(equalTo: self.topAnchor),
                outsidePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                insidePicker.widthAnchor.constraint(equalToConstant: calculatedPickerWidth),
                insidePicker.topAnchor.constraint(equalTo: self.topAnchor),
                insidePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                contrastPicker.widthAnchor.constraint(equalToConstant: calculatedPickerWidth),
                contrastPicker.topAnchor.constraint(equalTo: self.topAnchor),
                contrastPicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                
                outsidePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: pickerLeadingOffset),
                insidePicker.leadingAnchor.constraint(equalTo: outsidePicker.trailingAnchor, constant: calculatedPickerSapcing),
                contrastPicker.leadingAnchor.constraint(equalTo: insidePicker.trailingAnchor, constant: calculatedPickerSapcing),
                
                mask.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                mask.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                mask.topAnchor.constraint(equalTo: self.topAnchor),
                mask.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            
            outsidePicker.setLayoutContraintsForScroll()
            insidePicker.setLayoutContraintsForScroll()
            contrastPicker.setLayoutContraintsForScroll()
        }
    }
}

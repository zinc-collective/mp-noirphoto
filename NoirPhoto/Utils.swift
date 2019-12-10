//
//  Utils.swift
//  NoirPhoto
//
//  Created by Sean Hess on 5/24/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
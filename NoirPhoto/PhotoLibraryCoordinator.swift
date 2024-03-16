//
//  PhotoLibraryProvider.swift
//  NoirPhoto
//
//  Created by Cricket on 3/9/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation


protocol PhotoProvider: UIViewController {
    func getMetaData(assetURL: NSURL) -> NSMutableDictionary
}

class PhotoLibraryCoordinator {
    var delegate: UIViewController
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
}

extension PhotoProvider {
    
}

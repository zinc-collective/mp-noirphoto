//
//  PhotoLibraryProvider.swift
//  NoirPhoto
//
//  Created by Cricket on 3/9/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation
import PhotosUI


protocol PhotoProvider {
    func getMetaData(assetURL: NSURL) -> NSMutableDictionary
    func getMetaData(assetIdentifier: String) -> NSMutableDictionary
    func getPhoto(_ completion: @escaping (CGImage?, String?) -> Void)
}


class PhotoLibraryCoordinator {
    var picker: PHPickerViewController?
    weak var parent: UIViewController?
    private var imageCompletion: ((CGImage?, String?) -> Void)?
    
    private var selection = [String: PHPickerResult]()
    private var currentAssetIdentifier: String?
    
    init(parent: UIViewController) {
        self.parent = parent
    }
}


// MARK: - Private Methods
private extension PhotoLibraryCoordinator {
    func presentPicker(filter: PHPickerFilter?) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        // Set the filter type according to the user’s selection.
        configuration.filter = filter
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = self.selection.map({ $0.key })
        
        if self.picker == nil {
            self.picker = PHPickerViewController(configuration: configuration)
        }
        guard let picker = self.picker else { return }
        picker.delegate = self
        parent?.present(picker, animated: true)
    }
}


// MARK: - PhotoProvider
extension PhotoLibraryCoordinator: PhotoProvider {
    func getMetaData(assetURL: NSURL) -> NSMutableDictionary {
        return [String: Any]() as! NSMutableDictionary
    }
    
    func getMetaData(assetIdentifier: String) -> NSMutableDictionary {
        return [String: Any]() as! NSMutableDictionary
    }
    
    func getPhoto(_ completion: @escaping (CGImage?, String?) -> Void) {
        self.imageCompletion = completion
        self.presentPicker(filter: nil)
    }
}


// MARK: - PHPickerViewControllerDelegate
extension PhotoLibraryCoordinator: PHPickerViewControllerDelegate {
    /// - Tag: ParsePickerResults
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // Track the selection in case the user deselects it later.
        let assetIdentifier = updateSelectionVars(results)
        executeCompletion(assetIdentifier: assetIdentifier)
    }
    
    // This is a terrible function name
    private func updateSelectionVars(_ results: [PHPickerResult]) -> String? {
        let existingSelection = self.selection
        var newSelection = [String: PHPickerResult]()
        for result in results {
            if let identifier = result.assetIdentifier {
                self.currentAssetIdentifier = identifier
                newSelection[identifier] = existingSelection[identifier] ?? result
            } else {
                assertionFailure("Result obj was ignored becasue it has no assetIdentifier.")
            }
        }
        self.selection = newSelection
        return self.currentAssetIdentifier
    }
    
    private func executeCompletion(assetIdentifier: String?) {
        guard let identifier = assetIdentifier,
              let completion = self.imageCompletion,
              let itemProvider = self.selection[identifier]?.itemProvider else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("####-----> ERROR: \(error.localizedDescription)")
                    assertionFailure("####-----> ERROR: FAILURE")
                } else {
                    assert(object != nil, "####-----> OBJECT should not be nil")
                    //                    NSAssert(object != nil, @"UIImage should not be nil");
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            completion(image.cgImage, identifier)
                        }
                    }
                }
            }
        } else {
            assert(true, "###---> Not an UIImage")
        }
    }
    
    private func handleCompletion(assetIdentifier: String, object: Any?, error: Error? = nil) {
        guard self.currentAssetIdentifier == assetIdentifier else { return }
        
        if let livePhoto = object as? PHLivePhoto {
//            displayLivePhoto(livePhoto)
        } else if let image = object as? UIImage {
//            displayImage(image)
        } else if let url = object as? URL {
//            displayVideoPlayButton(forURL: url)
        } else if let error = error {
            print("Couldn't display \(assetIdentifier) with error: \(error)")
//            displayErrorImage()
        } else {
//            displayUnknownImage()
        }
    }
}


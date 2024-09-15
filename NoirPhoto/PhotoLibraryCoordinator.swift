//
//  PhotoLibraryCoordinator.swift
//  NoirPhoto
//
//  Created by Cricket on 9/2/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import Foundation
import PhotosUI


protocol PhotoProvider {
    func getMetaData(assetURL: NSURL) -> NSMutableDictionary?
    func getMetaData(assetIdentifier: String) -> NSMutableDictionary?
    func getPhoto(_ completion: @escaping (CGImage?, String?) -> Void)
}

protocol PhotoProviderDelegate : AnyObject {
    func providerDidPickImage(_ image: UIImage, assetIdentifier: String)
}


class PhotoLibraryCoordinator {
    var picker: PHPickerViewController?
    var logger: AppLogger?
    weak var parent: UIViewController?
    private var imageCompletion: ((CGImage?, String?) -> Void)?
    
    private var selection = [String: PHPickerResult]()
    private var currentAssetIdentifier: String?
    private lazy var imageRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, error, _, info in
            if let error = error {
                print("###! -> iCLoud Image Error: \(String(describing: error)) ==> \(String(describing: info))")
            } else {
                print("###! -> Donwload Progress: \(progress) ==> \(String(describing: info))")
            }
        }
        return options
    }()
    private lazy var livePhotoRequestOptions: PHLivePhotoRequestOptions = {
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, error, _, info in
            if let error = error {
                print("###! -> iCLoud LiveImage Error: \(String(describing: error)) ==> \(String(describing: info))")
            } else {
                print("###! -> Donwload Progress: \(progress) ==> \(String(describing: info))")
            }
        }
        return options
    }()
    private lazy var requestOptions: PHAssetResourceRequestOptions = {
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress in
            print("###! -> Request Donwload Progress: \(progress)")
        }
        return options
    }()
    
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
    func getMetaData(assetURL: NSURL) -> NSMutableDictionary? {
        return NSMutableDictionary(dictionary: [String: Any]())
    }
    
    func getMetaData(assetIdentifier: String) -> NSMutableDictionary? {
        print("### -> assetID: \(assetIdentifier)")
        var metadata: NSMutableDictionary?
        // from: https://codermite.com/t/extracting-image-meta-data-from-a-picture/
        if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil).firstObject {
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { (data, _, orientation, info) in
                print("### -> Orientation: \(orientation)")
                guard let data = data else {
                    print("### -> Cannot fetch data from PHAsset: \(String(describing: info))")
                    return
                }
                
                guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                    print("### -> Cannot create image source")
                    return
                }
                
                let options: [NSString: Any] = [kCGImageSourceShouldCache: false]
                guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary) as? [NSString: Any] else {
                    print("### -> Cannot fetch image properties")
                    return
                }
                print("### -> got it: -> \(imageProperties)")
                metadata = NSMutableDictionary(dictionary: imageProperties)
            }
        }
//        return NSMutableDictionary(dictionary: [String: Any]())
        print("### -> getMetaData: -> \(metadata)")
        return metadata
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
    // this is a terrible function.
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
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier],
                                               options: nil).firstObject {
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .aspectFit,
                                                      options: imageRequestOptions,
                                                      resultHandler: { [weak self] photo, info in
                    guard let img = photo else {
                        print("###! -> PHOTO NOT FOUND -> \(String(describing: info))")
                        // should display user error message here
                        // this is not an appropriate error message -- too technical, not localized, needs public safe error code
                        DispatchQueue.main.async {
                            if let vc = self?.picker?.presentingViewController {
                                Alert.showAlert(on: vc, title: "Loading Error", message: "The full version of the selected LiveImage is not on device and this app is unable to download selected image from iCloud")
                            }
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(img.cgImage, identifier)
                    }
                })
            }
        } else if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier],
                                               options: nil).firstObject {
                PHImageManager.default().requestLivePhoto(for: asset,
                                                          targetSize: PHImageManagerMaximumSize,
                                                          contentMode: .aspectFit,
                                                          options: livePhotoRequestOptions,
                                                          resultHandler: { [weak self] livePhoto, info in
                    guard let img = livePhoto else {
                        print("###! -> LivePhoto NOT FOUND -> \(String(describing: info))")
                        return
                    }
                    
                    let resources = PHAssetResource.assetResources(for: img)
                    let photo = resources.first(where: { $0.type == .photo })!
                    let imageData = NSMutableData()
                    PHAssetResourceManager.default().requestData(for: photo,
                                                                 options: self?.requestOptions,
                                                                 dataReceivedHandler: { data in
                        imageData.append(data)
                    }, completionHandler: { [weak self] error in
                        guard error == nil else {
                            print("###! -> error: \(String(describing: error))")
                            // should display user error message here
                            // this is not an appropriate error message -- too technical, not localized, needs public safe error code
                            DispatchQueue.main.async {
                                if let vc = self?.picker?.presentingViewController {
                                    Alert.showAlert(on: vc, title: "Loading Error", message: "The full version of the selected LiveImage is not on device and this app is unable to download selected image from iCloud")
                                }
                            }
                            return
                        }
                        
                        if let tempImg = UIImage(data: imageData as Data) {
                            DispatchQueue.main.async {
                                completion(tempImg.cgImage, identifier)
                            }
                        }
                    })
                })
            }
        } else {
            // should eventually log the type that that couldn't be processed
            assert(false, "###---> Unable to process resource")
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


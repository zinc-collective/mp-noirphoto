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
    func getMetaData(assetIdentifier: String, completion: @escaping (Result<NSMutableDictionary?, Error>) -> Void)
    func getPhoto(_ completion: @escaping (CGImage?, String?) -> Void)
}

protocol PhotoProviderDelegate : AnyObject {
    func providerDidPickImage(_ image: UIImage, assetIdentifier: String)
}


class PhotoLibraryCoordinator {
    enum PhotoProviderError: LocalizedError {
        case UnknownAssetLoadFailed(info: Dictionary<AnyHashable, Any>? = nil)
        case ImageLoadingFailedHEIC(error: Error? = nil)
        case ImageRequestDownloadFailed(info: Dictionary<AnyHashable, Any>? = nil, error: Error? = nil)
        case LivePhotoRequestDownloadFailed(info: Dictionary<AnyHashable, Any>? = nil, error: Error? = nil)
        case RequestDownloadFailed(error: Error?)
        case MetaDataFetchRequestFailed(info: Dictionary<AnyHashable, Any>? = nil)
        case MetaDataImageFetchFailed(info: Dictionary<AnyHashable, Any>? = nil)
        case MetaDataImageCopyFailed(info: Dictionary<AnyHashable, Any>? = nil)
        
        public var errorDescription: String? {
            switch self {
            case .UnknownAssetLoadFailed(let info):
                return formatErrorMsg(errorCode: "PH_0003", info: info)
            case .ImageRequestDownloadFailed(let info, let error):
                return formatErrorMsg(errorCode: "PH_0004", info: info, error: error)
            case .ImageLoadingFailedHEIC(let error):
                return formatErrorMsg(errorCode: "PH_0012", error: error)
            case .LivePhotoRequestDownloadFailed(let info, let error):
                return formatErrorMsg(errorCode: "PH_0005", info: info, error: error)
            case .RequestDownloadFailed(let error):
                return formatErrorMsg(errorCode: "PH_0006", error: error)
            case .MetaDataFetchRequestFailed(let info):
                return formatErrorMsg(errorCode: "PH_0007", info: info)
            case .MetaDataImageFetchFailed(let info):
                return formatErrorMsg(errorCode: "PH_0008", info: info)
            case .MetaDataImageCopyFailed(let info):
                return formatErrorMsg(errorCode: "PH_0009", info: info)
            
            // A good default error msg if I need one later
            // String(localized: "PH_0000")
            }
        }
        
        private func formatErrorMsg(errorCode: String.LocalizationValue,
                                 info: Dictionary<AnyHashable, Any>? = nil,
                                 error: Error? = nil) -> String {
            var response: String = String(localized: errorCode)
            if let info = info {
                response += " | Info: \(String(describing: info))"
            }
            if let error = error {
                response += " | Error: \(String(describing: error))"
            }
            return response
        }
    }

    var progressView: UIProgressView?
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
                self.logger?.logToConsole("###! -> iCLoud Image Error: \(String(describing: error)) ==> \(String(describing: info))",
                                          .info,
                                          .photoLibraryCoordinator)
            } else {
                self.displayProgress(Float(progress))
                self.logger?.logToConsole("###! -> Donwload Progress: \(progress) ==> \(String(describing: info))",
                                          .info,
                                          .photoLibraryCoordinator)
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
                self.logger?.logToConsole("###! -> iCLoud LiveImage Error: \(String(describing: error)) ==> \(String(describing: info))",
                                          .info,
                                          .photoLibraryCoordinator)
            } else {
                self.displayProgress(Float(progress))
                self.logger?.logToConsole("###! -> Donwload Progress: \(progress) ==> \(String(describing: info))",
                                          .info,
                                          .photoLibraryCoordinator)
            }
        }
        return options
    }()
    private lazy var requestOptions: PHAssetResourceRequestOptions = {
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress in
            self.displayProgress(Float(progress))
            self.logger?.logToConsole("###! -> Request Donwload Progress: \(progress)",
                                      .info,
                                      .photoLibraryCoordinator)
        }
        return options
    }()
    
    init(parent: UIViewController) {
        self.parent = parent
    }
}


// MARK: - Private Methods
private extension PhotoLibraryCoordinator {
    func presentPicker(filter: PHPickerFilter?, delegate: PHPickerViewControllerDelegate? = nil) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        // Set the filter type according to the user’s selection.
        configuration.filter = filter ?? PHPickerFilter.any(of: [
            .images,
            .livePhotos,
            .screenshots
        ])
        // Set the mode to avoid transcoding, if possible, if your app supports arbitrary image/video encodings.
        configuration.preferredAssetRepresentationMode = .current
        // Set the selection behavior to respect the user’s selection order.
        configuration.selection = .ordered
        // Set the selection limit to enable multiselection.
        configuration.selectionLimit = 1
        // Set the preselected asset identifiers with the identifiers that the app tracks.
        configuration.preselectedAssetIdentifiers = []
        
        self.picker = PHPickerViewController(configuration: configuration)
        guard let picker = self.picker else { return }
        picker.delegate = delegate ?? self
        parent?.present(picker, animated: true)
    }
    
    func displayProgress(_ progress: Float) {
        DispatchQueue.main.async {
            self.progressView?.isHidden = progress >= 1.0
            self.progressView?.setProgress(progress, animated: true)
        }
    }
}


// MARK: - PhotoProvider
extension PhotoLibraryCoordinator: PhotoProvider {
    func getMetaData(assetURL: NSURL) -> NSMutableDictionary? {
        return NSMutableDictionary(dictionary: [String: Any]())
    }
    
    func getMetaData(assetIdentifier: String, completion: @escaping (Result<NSMutableDictionary?, Error>) -> Void) {
        // from: https://codermite.com/t/extracting-image-meta-data-from-a-picture/
        if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil).firstObject {
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { (data, _, orientation, info) in
                var filteredInfo = info ?? [AnyHashable: Any]()
                filteredInfo.updateValue("[redacted]", forKey: "PHImageFileDataKey") // do not send photo data to logger/bug tracker
                
                self.logger?.logToConsole("### -> Meta Data Orientation: \(orientation)",
                                          .info,
                                          .photoLibraryCoordinator)
                
                guard let data = data else {
                    completion(.failure(PhotoProviderError.MetaDataFetchRequestFailed(info: filteredInfo)))
                    return
                }
                
                guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                    completion(.failure(PhotoProviderError.MetaDataImageFetchFailed(info: filteredInfo)))
                    return
                }
                
                let options: [NSString: Any] = [kCGImageSourceShouldCache: false]
                guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary) as? [NSString: Any] else {
                    completion(.failure(PhotoProviderError.MetaDataImageCopyFailed(info: filteredInfo)))
                    return
                }
                
                let metadata: NSMutableDictionary? = NSMutableDictionary(dictionary: imageProperties)
                self.logger?.logToConsole("### -> getMetaData: -> \(String(describing: metadata))",
                                           .default,
                                           .photoLibraryCoordinator)
                completion(.success(metadata))
            }
        }
    }
    
    func getPhoto(_ completion: @escaping (CGImage?, String?) -> Void) {
        self.imageCompletion = completion
        self.presentPicker(filter: nil, delegate: self)
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
                        self?.logger?.logError(PhotoProviderError.ImageRequestDownloadFailed(info: info))
                        guard let parent = self?.parent else { return }
                        DispatchQueue.main.async {
                            Alert.showAlert(on: parent,
                                            title: String(localized: "PH_Title_LoadingError"),
                                            message: String(localized: "PH_0002"))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        completion(img.cgImage, identifier)
                    }
                })
            } else {
                // nil UIImage asset"
                guard let parent = self.parent else { return }
                DispatchQueue.main.async {
                    Alert.showAlert(on: parent,
                                    title: String(localized: "PH_Title_LimitedAccess_Image"),
                                    message: String(localized: "PH_0010")) { _ in
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self,
                                  let parent = self.parent else { return }
                            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: parent)
                        }
                    }
                }
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
                        self?.logger?.logError(PhotoProviderError.LivePhotoRequestDownloadFailed(info: info))
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
                            self?.logger?.logError(PhotoProviderError.RequestDownloadFailed(error: error))
                            guard let parent = self?.parent else { return }
                            DispatchQueue.main.async {
                                Alert.showAlert(on: parent,
                                                title: String(localized: "PH_Title_LoadingError"),
                                                message: String(localized: "PH_0001"))
                            }
                            return
                        }
                        
                        if let tempImg = UIImage(data: imageData as Data) {
                            let imageWithCorrectedOrientation = tempImg.rotateCameraImageToProperOrientation(CGFloat(MAXFLOAT))
                            DispatchQueue.main.async {
                                completion(imageWithCorrectedOrientation.cgImage, identifier)
                            }
                        }
                    })
                })
            } else { 
                // nil LivePhoto asset"
                guard let parent = self.parent else { return }
                DispatchQueue.main.async {
                    Alert.showAlert(on: parent,
                                    title: String(localized: "PH_Title_LimitedAccess_Image"),
                                    message: String(localized: "PH_0011")) { _ in
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self,
                                  let parent = self.parent else { return }
                            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: parent)
                        }
                    }
                }
            }
        } else {
            // The HEIC (format) Exception - it SHOULD work with UIImage.self; but it does not; so this is required.
            // Forum references: https://forums.developer.apple.com/forums/thread/658135
            _ = itemProvider.loadDataRepresentation(forTypeIdentifier: "public.heic", completionHandler: { [weak self] (data, error) in
                if let imageData = data,
                   let img = UIImage(data: imageData) {
                    let imageWithCorrectedOrientation = img.rotateCameraImageToProperOrientation(CGFloat(MAXFLOAT))
                    DispatchQueue.main.async {
                        completion(imageWithCorrectedOrientation.cgImage, "NO ID")
                    }
                } else {
                    guard let self = self else { return }
                    logger?.logError(PhotoProviderError.ImageLoadingFailedHEIC(error: error))
                    logger?.logError(PhotoProviderError.UnknownAssetLoadFailed(info: ["failedType": itemProvider.registeredTypeIdentifiers]))
                    
                    guard let parent = self.parent else { return }
                    DispatchQueue.main.async {
                        Alert.showAlert(on: parent,
                                        title: String(localized: "PH_Title_LoadingError"),
                                        message: String(localized: "PH_0003"))
                    }
                }
            })
        }
    }
}


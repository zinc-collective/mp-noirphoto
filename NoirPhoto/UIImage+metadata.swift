//
//  UIImage+metadata.swift
//  NoirPhoto
//
//  Created by Sean Hess on 4/29/16.
//  Copyright © 2019 Zinc Collective, LLC. All rights reserved.
//

import Foundation
import ImageIO

extension UIImage {

    class func stripOrientationMetadata(_ meta:NSDictionary) -> NSDictionary {
        let metaCopy = NSMutableDictionary(dictionary: meta)
        metaCopy.removeObject(forKey: "Orientation")
        return metaCopy
    }

    func imageWithMetadata(_ metadata:NSDictionary) -> Data? {
        let destData = NSMutableData()

        if let photoData = self.jpegData(compressionQuality: 1.0), let source = CGImageSourceCreateWithData(photoData as CFData, nil), let uti = CGImageSourceGetType(source), let destination = CGImageDestinationCreateWithData(destData, uti, 1, nil) {
            CGImageDestinationAddImageFromSource(destination, source, 0, metadata)

            if CGImageDestinationFinalize(destination) {
                return destData as Data
            }
            else {
                return nil
            }
        }
        return nil
    }

    // thank you stack overflow!
    // http://stackoverflow.com/questions/10600613/ios-image-orientation-has-strange-behavior
    func rotateCameraImageToProperOrientation(_ maxResolution : CGFloat) -> UIImage {

        let imageSource = self

        let imgRef = imageSource.cgImage;

        let width = CGFloat((imgRef?.width)!);
        let height = CGFloat((imgRef?.height)!);

        var bounds = CGRect(x: 0, y: 0, width: width, height: height)

        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {

            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }

        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat((imgRef?.width)!), height: CGFloat((imgRef?.height)!))


        switch(imageSource.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity

        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);

        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: CGFloat(M_PI));

        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);

        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);

        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);

        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0);

        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0);

        }

        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()

        if orient == .right || orient == .left {
            context?.scaleBy(x: -scaleRatio, y: scaleRatio);
            context?.translateBy(x: -height, y: 0);
        } else {
            context?.scaleBy(x: scaleRatio, y: -scaleRatio);
            context?.translateBy(x: 0, y: -height);
        }

        context?.concatenate(transform);
        UIGraphicsGetCurrentContext()?.draw(imgRef!, in: CGRect(x: 0, y: 0, width: width, height: height));

        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return imageCopy!;
    }

}

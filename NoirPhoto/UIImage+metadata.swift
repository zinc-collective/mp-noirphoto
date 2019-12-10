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

    class func stripOrientationMetadata(meta:NSDictionary) -> NSDictionary {
        let metaCopy = NSMutableDictionary(dictionary: meta)
        metaCopy.removeObjectForKey("Orientation")
        return metaCopy
    }

    func imageWithMetadata(metadata:NSDictionary) -> NSData? {
        let destData = NSMutableData()

        if let photoData = UIImageJPEGRepresentation(self, 1.0), source = CGImageSourceCreateWithData(photoData, nil), uti = CGImageSourceGetType(source), destination = CGImageDestinationCreateWithData(destData, uti, 1, nil) {
            CGImageDestinationAddImageFromSource(destination, source, 0, metadata)

            if CGImageDestinationFinalize(destination) {
                return destData
            }
            else {
                return nil
            }
        }
        return nil
    }

    // thank you stack overflow!
    // http://stackoverflow.com/questions/10600613/ios-image-orientation-has-strange-behavior
    func rotateCameraImageToProperOrientation(maxResolution : CGFloat) -> UIImage {

        let imageSource = self

        let imgRef = imageSource.CGImage;

        let width = CGFloat(CGImageGetWidth(imgRef));
        let height = CGFloat(CGImageGetHeight(imgRef));

        var bounds = CGRectMake(0, 0, width, height)

        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {

            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }

        var transform = CGAffineTransformIdentity
        let orient = imageSource.imageOrientation
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))


        switch(imageSource.imageOrientation) {
        case .Up :
            transform = CGAffineTransformIdentity

        case .UpMirrored :
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);

        case .Down :
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI));

        case .DownMirrored :
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);

        case .Left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);

        case .LeftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0);

        case .Right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);

        case .RightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0);

        }

        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()

        if orient == .Right || orient == .Left {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        } else {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }

        CGContextConcatCTM(context, transform);
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);

        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return imageCopy;
    }

}
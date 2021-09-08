//
//  Generator.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/16.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import ImageIO
import Cocoa

/// Function to generate GIF file from a list of `NSImage`, with delays specified with a list of Doubles.
/// - parameter photos: An array of `NSImage` for the images to be used.
/// - parameter delays: An array of `Double` that shows the delays.
/// - parameter path: The path to the output position.
/// - parameter filename: The filename for the output file.
func generateGIF(from photos: [NSImage], delays: [Double], path: String, filename: String) -> Bool {
    guard photos.count > 0 else { return false }

    // Output
    let outputPath = path.appending(filename)
    let outputUrl = URL(fileURLWithPath: outputPath) as CFURL

    // Properties
    let imageProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]] as CFDictionary?
    var gifProperties = delays.map({ [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: $0]] })
    gifProperties = [gifProperties.last!] + gifProperties[0..<gifProperties.index(before: gifProperties.endIndex)]

    if let des = CGImageDestinationCreateWithURL(outputUrl, kUTTypeGIF, photos.count, nil) {
        CGImageDestinationSetProperties(des, imageProperties)
        for (index, photo) in photos.enumerated() {
            var rect = CGRect.init(x:0, y:0, width: photo.size.width, height: photo.size.height)
            let image = photo.cgImage(forProposedRect: &rect, context: nil, hints: nil)!
            CGImageDestinationAddImage(des, image, gifProperties[index] as CFDictionary?)
        }
        return CGImageDestinationFinalize(des)
    }

    return false
}


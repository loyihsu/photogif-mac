//
//  Generator.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/16.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import ImageIO
import Cocoa

/// Function to generate GIF file.
func generateGIF(from photos: [NSImage], delays: [Double], path: String, filename: String) -> Bool {
    guard photos.count > 0 else { return false }
    // Output
    let outputPath = path.appending(filename)
    let outputUrl = URL.init(fileURLWithPath: outputPath) as CFURL
    // Properties
    let imageProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]] as CFDictionary?
    var gifProperties = delays.map { [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: $0]] }
    gifProperties.insert(gifProperties.popLast()!, at: 0)
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


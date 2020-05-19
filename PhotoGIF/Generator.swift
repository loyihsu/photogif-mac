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
func generateGIF(from photos: [NSImage], delays: [Double], docDirPath: String, filename: String) -> Bool {
    if photos.count < 1 { return false }
    
    let outputPath = docDirPath.appending(filename)
    
    // Properties
    let fileProp = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
    var gifProp = delays.map { [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: $0]] }
    gifProp.insert(gifProp.popLast()!, at: 0)
    
    let cfURL = URL.init(fileURLWithPath: outputPath) as CFURL
    
    if let des = CGImageDestinationCreateWithURL(cfURL, kUTTypeGIF, photos.count, nil) {
        CGImageDestinationSetProperties(des, fileProp as CFDictionary?)
        
        for (index, photo) in photos.enumerated() {
            var rect = CGRect.init(x:0, y:0, width: photo.size.width, height: photo.size.height)
            let image = photo.cgImage(forProposedRect: &rect, context: nil, hints: nil)!
            CGImageDestinationAddImage(des, image, gifProp[index] as CFDictionary?)
        }
        return CGImageDestinationFinalize(des)
    }
    
    return false
}

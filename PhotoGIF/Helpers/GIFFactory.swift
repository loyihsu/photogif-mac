//
//  GIFFactory.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa

protocol GIFFactory {
    /// Generate a GIF image, with delays specified with a list of Doubles.
    /// - parameter sources: Source files.
    /// - parameter path: The path to the output location.
    /// - parameter filename: The filename for the output file.
    /// - returns: Whether the operation succeeded.
    func make(
        with sources: [Source],
        path: String,
        filename: String
    ) -> Bool
}

struct DefaultGIFFactory: GIFFactory {
    func make(with sources: [Source], path: String, filename: String) -> Bool {
        guard sources.count > 0 else { return false }

        let outputPath = path.appending(filename)
        let outputUrl = URL(fileURLWithPath: path) as CFURL

        let imageProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]] as CFDictionary?

        let gifProperties = sources.map(\.length)
            .map { [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: $0]] }

        guard let destination = CGImageDestinationCreateWithURL(outputUrl, kUTTypeGIF, sources.count, nil) else {
            return false
        }

        CGImageDestinationSetProperties(destination, imageProperties)

        for (index, image) in sources.enumerated() {
            let nsImage = image.nsImage
            var rect = CGRect(x: 0, y: 0, width: nsImage.size.width, height: nsImage.size.height)
            let image = nsImage.cgImage(forProposedRect: &rect, context: nil, hints: nil)!
            CGImageDestinationAddImage(destination, image, gifProperties[index] as CFDictionary?)
        }

        return CGImageDestinationFinalize(destination)
    }
}

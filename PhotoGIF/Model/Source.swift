//
//  Source.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

/**
  The `Source` data structure.
  - parameter `id`: The unique id for each item.
  - parameter `location`: The file location.
  - parameter `length`: The time the screen should stay in the output gif file.
  - parameter `displayName`: The name to display on screen.
  - parameter `nsImage`: The `NSImage` object for the `Source` file.
 */
struct Source: Identifiable, Equatable {
    static let supportedTypes = ["jpeg", "jpg", "png", "ai", "bmp", "tif", "tiff", "heic", "psd"]

    var id = UUID()
    var location: String
    var length: String
    var displayName: String { self.location.lastElement().removingPercentEncoding ?? self.location.lastElement() }
    var nsImage: NSImage

    var hasValidLength: Bool {
        self.validSeconds(self.length) && !self.length.isEmpty
    }

    /// Function to validate the seconds.
    /// - parameter str: String to validate.
    private func validSeconds(_ str: String) -> Bool {
        return str.first != "." && str.last != "." && str.count(where: { $0 == "." }) <= 1
    }
}

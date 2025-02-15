//
//  Source.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa
import UniformTypeIdentifiers

/// The representation of imported images.
struct Source: Identifiable, Equatable {
    static let supportedTypes: [UTType] = [.jpeg, .png, .bmp, .tiff, .heic]

    var id = DependencyHelper.shared.nextUuid()
    var location: String
    var length: String
    var displayName: String {
        self.location.lastFileElement().removingPercentEncoding
            ?? self.location.lastFileElement()
    }

    var nsImage: NSImage

    var hasValidLength: Bool {
        [
            DecimalNumberOnlyValidator(),
            ValidDecimalPointValidator(),
            NonEmptyValidator(),
        ]
        .validate(self.length)
    }
}

//
//  NSImageKey.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import Dependencies

extension DependencyValues {
    var nsImage: (URL) -> NSImage? {
        get {
            self[NSImageKey.self]
        }
        set {
            self[NSImageKey.self] = newValue
        }
    }

    private enum NSImageKey: DependencyKey {
        static let liveValue: ((URL) -> NSImage?) = { url in
            NSImage(contentsOf: url)
        }
    }
}

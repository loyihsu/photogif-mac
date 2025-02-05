//
//  GifFactoryKey.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Dependencies

extension DependencyValues {
    var gifFactory: GIFFactory {
        get {
            self[GifFactoryKey.self]
        }
        set {
            self[GifFactoryKey.self] = newValue
        }
    }

    private enum GifFactoryKey: DependencyKey {
        static let liveValue: any GIFFactory = DefaultGIFFactory()
    }
}

//
//  BundleKey.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import Dependencies

extension DependencyValues {
    var bundle: (BundleKey) -> String {
        get {
            self[BundleDependencyKey.self]
        }
        set {
            self[BundleDependencyKey.self] = newValue
        }
    }

    enum BundleKey: String {
        case appName = "CFBundleName"
        case versionString = "CFBundleShortVersionString"
        case buildString = "CFBundleVersion"
        case copyrightString = "NSHumanReadableCopyright"
    }

    private enum BundleDependencyKey: DependencyKey {
        static let liveValue: (BundleKey) -> String = { key in
            (Bundle.main.infoDictionary?[key.rawValue] as? String) ?? ""
        }
    }
}

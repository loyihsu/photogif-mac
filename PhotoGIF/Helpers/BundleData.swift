//
//  BundleData.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Foundation

enum BundleData: String {
    case appName = "CFBundleName"
    case versionString = "CFBundleShortVersionString"
    case buildString = "CFBundleVersion"
    case copyrightString = "NSHumanReadableCopyright"

    func string(using proxy: any BundleProxy = DefaultBundleProxy()) -> String? {
        return proxy.getValue(for: self.rawValue)
    }
}

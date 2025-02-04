//
//  BundleProxy.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Foundation

protocol BundleProxy {
    func getValue(for key: String) -> String?
}

struct DefaultBundleProxy: BundleProxy {
    func getValue(for key: String) -> String? {
        Bundle.main.infoDictionary?[key] as? String
    }
}

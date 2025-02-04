//
//  DirectoryProxy.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa

enum DirectoryProxy {
    case downloads

    var path: String {
        switch self {
        case .downloads:
            NSSearchPathForDirectoriesInDomains(
                .downloadsDirectory,
                .userDomainMask,
                true
            )[0]
        }
    }
}

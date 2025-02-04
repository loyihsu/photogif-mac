//
//  StringExtensions.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/4.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Foundation

extension String {
    /// Get the last non-empty element of the string (for path).
    func lastElement() -> String {
        return self
            .components(separatedBy: "/")
            .filter { $0.isEmpty == false }
            .last
            ?? NSLocalizedString(
                "image",
                comment: "A fallback placeholder for images that we cannot find the last path element."
            )
    }
}

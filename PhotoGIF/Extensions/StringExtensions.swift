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
    func lastFileElement() -> String {
        let fallback = "Image"

        guard self.contains("/") else { return fallback }

        let last = self
            .components(separatedBy: "/")
            .filter { $0.isEmpty == false }
            .last

        return last ?? fallback
    }
}

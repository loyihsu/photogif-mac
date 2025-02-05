//
//  DependencyHelper.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import Dependencies

final class DependencyHelper {
    @Dependency(\.uuid) var uuid

    static let shared = DependencyHelper()

    func nextUuid() -> UUID {
        self.uuid()
    }
}

//
//  LocalisationKey.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import Dependencies

extension DependencyValues {
    var localisation: (LocalisationKey) -> String {
        get {
            self[LocalisationDependencyKey.self]
        }
        set {
            self[LocalisationDependencyKey.self] = newValue
        }
    }

    enum LocalisationKey: String {
        case importImages = "import"
        case changeOutputPath = "change"
        case outputFilename = "filename"
        case generate
        case second
        case seconds
        case clear
    }

    private enum LocalisationDependencyKey: DependencyKey {
        static let liveValue: (LocalisationKey) -> String = { key in
            NSLocalizedString(key.rawValue, comment: "")
        }
    }
}

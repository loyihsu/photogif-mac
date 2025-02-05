//
//  FileOpenPanelKey.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import Dependencies

extension DependencyValues {
    var fileOpenPanel: (([URL]) -> Void) -> Void {
        get {
            self[FileOpenPanelKey.self]
        }
        set {
            self[FileOpenPanelKey.self] = newValue
        }
    }

    private enum FileOpenPanelKey: DependencyKey {
        static let liveValue: ((([URL]) -> Void) -> Void) = { completion in
            let panel = NSOpenPanel()

            panel.allowsMultipleSelection = true
            panel.allowedContentTypes = Source.supportedTypes

            let result = panel.runModal()

            guard result == .OK else { return }

            completion(panel.urls)
        }
    }
}

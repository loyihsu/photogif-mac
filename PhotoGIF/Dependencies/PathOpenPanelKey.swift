//
//  PathOpenPanelKey.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import Dependencies

extension DependencyValues {
    var pathOpenPanel: ((String) -> Void) -> Void {
        get {
            self[PathOpenPanelKey.self]
        }
        set {
            self[PathOpenPanelKey.self] = newValue
        }
    }

    private enum PathOpenPanelKey: DependencyKey {
        static let liveValue: (((String) -> Void) -> Void) = { completion in
            let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false

            let result = panel.runModal()

            guard result == .OK, let string = panel.url?.absoluteString else { return }

            let path = string.replacingOccurrences(of: "file://", with: "")
            completion(path.removingPercentEncoding ?? path)
        }
    }
}

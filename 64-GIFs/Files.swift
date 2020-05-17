//
//  Files.swift
//  64-GIFs
//
//  Created by Loyi on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

func selectPath() -> String? {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false

    let result = panel.runModal()
    if result == .OK {
        if let str = panel.url?.absoluteString {
            return str.components(separatedBy: "file://").joined()
        }
    }

    return nil
}

func openDocument(_ sources: inout [Source]) {
    let panel = NSOpenPanel()

    panel.allowsMultipleSelection = true
    panel.allowedFileTypes = acceptableTypes

    let result = panel.runModal()
    if result == .OK {
        for url in panel.urls {
            append(url, to: &sources)
        }
    }
}

func append(_ item: URL, to sources: inout [Source]) {
    if acceptableTypes.contains(item.pathExtension.lowercased()) {
        if let image = NSImage.init(contentsOf: item) {
            print(item)

            let str = item.absoluteString.components(separatedBy: "file://").joined()

            sources.append(Source.init(
                id: inputCount,
                location: str,
                length: "1",
                nsImage: image)
            )

            inputCount += 1
            return
        }
    }

    let _ = showAlert("\(item.absoluteString.lastElement()) cannot be recognised.")
}

func formatFilename(_ str: String) -> String {
    return str.components(separatedBy: ".gif").joined()
}

extension String {
    func lastElement() -> String {
        return self.components(separatedBy: "/").filter { $0.isEmpty == false }.last ?? "Image"
    }
}

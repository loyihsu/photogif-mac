//
//  Files.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

let acceptableTypes = ["jpeg", "jpg", "png", "ai", "bmp", "tif", "tiff", "heic", "psd"]

/**
 The `Source` data structure.
 - parameter `id`: The unique id for each item for `Identifiable`
 - parameter `location`: The file location.
 - parameter `length`: The time the screen should stay in the output gif file.
 - parameter `displayName`: The name to display on screen.
 - parameter `nsImage`: The `NSImage` object for the `Source` file.
**/
struct Source: Identifiable, Equatable {
    var id = UUID()
    var location: String
    var length: String
    var displayName: String { location.lastElement().removingPercentEncoding ?? location.lastElement() }
    var nsImage: NSImage
}

extension Array where Element == Source {
    /// Implement `firstIndex(of:)` function `[Source]`.
    func firstIndex(of element: Element) -> Int? {
        return self.firstIndex(where: { $0.id == element.id })
    }
}

extension String {
    /// Get the last non-empty element of the string (for path).
    func lastElement() -> String {
        return self.components(separatedBy: "/").filter { $0.isEmpty == false }.last ?? "Image"
    }
}

/// Function to call the NSOpenPanel to select output path.
func selectPath() -> String? {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false

    let result = panel.runModal()
    if result == .OK {
        if let str = panel.url?.absoluteString {
            let path = str.components(separatedBy: "file://").joined()
            return path.removingPercentEncoding ?? path
        }
    }

    return nil
}

/// Function to ouput document and append item into the `FileList`.
/// - parameter list: The `FileList` containing the `[Source]` list.
func openDocument(list: FileList) {
    let panel = NSOpenPanel()

    panel.allowsMultipleSelection = true
    panel.allowedFileTypes = acceptableTypes

    let result = panel.runModal()
    if result == .OK {
        for url in panel.urls {
            list.append(url)
        }
    }
}

/// Function to strip .gif at the end of output filename.
func formatFilename(_ str: String) -> String {
    return str.components(separatedBy: ".gif").joined()
}

/// Function to show alert.
/// `issue`: Alert message.
func showAlert(_ issue: String) -> Bool {
    let alert: NSAlert = NSAlert()
    alert.messageText = issue
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    
    let res = alert.runModal()
    if res == .alertFirstButtonReturn { return true }
    return false
}

/// Function to validate the seconds to show seconds.
/// - parameter str: String to validate.
func validate(_ str: String) -> Bool {
    let output = str.filter { "0123456789.".contains($0) }
    let count = str.filter { $0 == "." }.count
    return str == output && count <= 1
}

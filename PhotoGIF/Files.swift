//
//  Files.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

/// `Source` structure
struct Source: Identifiable, Equatable {
    var id: Int                     // For `Identifiable`

    var location: String            // The file location.
    var length: String              // The time the screen should stay in the output gif file.

    var nsImage: NSImage            // NSImage render.

    var removed: Bool = false       // Removing the items directly would cause index out of range in SwiftUI.
                                    // Mark it as removed and filter the arrays by this signal instead.
}

extension Array where Element == Source {
    /// Implement `firstIndex(of:)` function `[Source]`.
    func firstIndex(of element: Element) -> Int? {
        return self.firstIndex(where: { $0.id == element.id })
    }
}

/// Function to clear `sources` array.
func clear(_ sources: inout [Source]) {
    var output = sources
    for (index, _) in output.enumerated() {
        output[index].removed = true
    }
    sources = output
}

extension String {
    /// Get the last non-empty element of the string (for path)
    func lastElement() -> String {
        return self.components(separatedBy: "/").filter { $0.isEmpty == false }.last ?? "Image"
    }
}

/// Function to call the NSOpenPanel to select output path
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

/// Function to ouput document and append item into the `[source]`.
/// - parameter sources: The `[Source]` array to append the items to. (pass by reference)
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

/// Function to append item to `[Source]`.
/// - parameter item: The `URL` of the item.
/// - parameter sources: The `[Source]` array to append the items to. (pass by reference)
func append(_ item: URL, to sources: inout [Source]) {
    if acceptableTypes.contains(item.pathExtension.lowercased()) {
        if let image = NSImage.init(contentsOf: item) {
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
    // Reachable when it is not recognised or NSImage can't be constructed.
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
//
//  FileList.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa
import IdentifiedCollections

struct FileList: Equatable {
    var sources = IdentifiedArrayOf<Source>()

    /// Append a list of sources `URL`.
    mutating func appendSources(_ array: [URL]) {
        for item in array {
            self.appendSource(item)
        }
    }

    /// The method to remove an item from the `sources` array.
    mutating func remove(_ item: Source) {
        self.sources.remove(item)
    }

    /// The method to remove all the items in the `sources` array.
    mutating func removeAllSources() {
        self.sources.removeAll()
    }

    mutating func moveUp(_ item: Source) {
        guard let idx = sources.firstIndex(of: item) else { return }

        guard idx != 0 else { return }

        let left = idx - 1
        let right = idx
        (self.sources[left], self.sources[right]) = (self.sources[right], self.sources[left])
    }

    mutating func moveDown(_ item: Source) {
        guard let idx = sources.firstIndex(of: item) else { return }

        guard idx + 1 < self.sources.count else { return }

        let left = idx
        let right = idx + 1
        (self.sources[left], self.sources[right]) = (self.sources[right], self.sources[left])
    }

    /// The method to edit the `length` an item from the `sources` array.
    /// - parameter item: The item to be edited.
    /// - parameter newValue: The new value.
    mutating func edit(_ item: Source, with newValue: String) {
        self.sources[id: item.id]?.length = newValue
    }

    /// Check whether the item is the first item in the `sources` array.
    /// - parameter item: The item to be checked.
    func isFirstSource(_ item: Source) -> Bool {
        self.sources.first == item
    }

    /// Check whether the item is the last item in the `sources` array
    /// - parameter item: The item to be checked.
    func isLastSource(_ item: Source) -> Bool {
        self.sources.last == item
    }

    // MARK: - Private Helpers

    private mutating func appendSource(_ item: URL) {
        guard let image = NSImage(contentsOf: item) else { return }

        let path = item.absoluteString.components(separatedBy: "file://").joined()

        self.sources.append(Source(location: path, length: "1", nsImage: image))
    }
}

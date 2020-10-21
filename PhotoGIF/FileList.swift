//
//  FileList.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/10/18.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

class FileList: ObservableObject {
    /// The `@Published` array that is readable but can only be modified with the functions defined within the `FileList` class.
    @Published private(set) var sources = [Source]()
    
    /// The count of items in the `sources` array.
    var count: Int { sources.count }
    
    /// Default initialiser.
    init() { }

    /// Initialise with existing `[Source]`.
    /// - parameter sources: The existing `[Source]` to create `FileList`.
    init(sources: [Source]) { self.sources = sources }
    
    /// Append items to the list.
    /// - parameter item: The `URL` of the image to append to the `sources` array.
    func append(_ item: URL) {
        if acceptableTypes.contains(item.pathExtension.lowercased()) {
            if let image = NSImage.init(contentsOf: item) {
                let str = item.absoluteString.components(separatedBy: "file://").joined()
                DispatchQueue.main.async {
                    self.sources.append(Source.init(location: str, length: "1", nsImage: image))
                }
                return
            }
        }

        let _ = showAlert("\(item.absoluteString.lastElement()) cannot be recognised.")
        // Reachable when it is not recognised or NSImage can't be constructed.
    }
    
    /// The method to move the item within the `sources` array.
    /// - parameter item: The `Source` item to be moved.
    /// - parameter dir: `true` = up, `false` = down
    func move(_ item: Source, dir: Bool) {
        guard let index = sources.firstIndex(of: item) else { return }
        DispatchQueue.main.async {
            if dir == true && index >= 1 {
                let temp = self.sources[index - 1]
                self.sources[index - 1] = self.sources[index]
                self.sources[index] = temp
            } else if dir == false && index < self.count - 1 {
                let temp = self.sources[index]
                self.sources[index] = self.sources[index + 1]
                self.sources[index + 1] = temp
            }
        }
    }
    
    /// The method to remove an item from the `sources` array.
    /// - parameter item: The `Source ` item to be removed.
    func remove(_ item: Source) {
        guard let index = sources.firstIndex(of: item) else { return }
        DispatchQueue.main.async {
            self.sources.remove(at: index)
        }
    }
    
    /// The method to edit the `length` an item from the `sources` array.
    /// - parameter item: The item to be edited.
    /// - parameter with: The new value.
    func edit(_ item: Source, with newValue: String) {
        guard let index = sources.firstIndex(of: item) else { return }
        DispatchQueue.main.async {
            self.sources[index].length = newValue
        }
    }
    
    /// The method to remove all the items in the `sources` array.
    func removeAll() {
        DispatchQueue.main.async {
            self.sources.removeAll()
        }
    }

    /// Check whether the item is the first item in the `sources` array.
    /// - parameter item: The item to be checked.
    func isFirstItem(_ item: Source) -> Bool {
        sources.first == item
    }
    
    /// Check whether the item is the last item in the `sources` array
    /// - parameter item: The item to be checked.
    func isLastItem(_ item: Source) -> Bool {
        sources.last == item
    }
}

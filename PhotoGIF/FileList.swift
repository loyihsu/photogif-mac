//
//  FileList.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/10/18.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

let acceptableTypes = ["jpeg", "jpg", "png", "ai", "bmp", "tif", "tiff", "heic", "psd"]
var inputCount = 0

class FileList: ObservableObject {
    @Published private(set) var sources = [Source]()
    var count: Int { sources.count }
    
    init() { }
    init(sources: [Source]) { self.sources = sources }
    
    func append(_ item: URL) {
        if acceptableTypes.contains(item.pathExtension.lowercased()) {
            if let image = NSImage.init(contentsOf: item) {
                let str = item.absoluteString.components(separatedBy: "file://").joined()

                sources.append(Source.init(location: str,
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
    
    func move(_ item: Source, dir: Bool) {
        guard let index = sources.firstIndex(of: item) else { return }
        if dir == true && index >= 1 {
            let temp = sources[index - 1]
            sources[index - 1] = sources[index]
            sources[index] = temp
        } else if dir == false && index < count - 1 {
            let temp = sources[index]
            sources[index] = sources[index + 1]
            sources[index + 1] = temp
        }
    }
    
    func remove(_ item: Source) {
        guard let index = sources.firstIndex(of: item) else { return }
        sources.remove(at: index)
    }
    
    func edit(_ item: Source, with newValue: String) {
        guard let index = sources.firstIndex(of: item) else { return }
        sources[index].length = newValue
    }
    
    func removeAll() {
        sources.removeAll()
    }
    
    func isFirstItem(_ item: Source) -> Bool {
        sources.first == item
    }
    
    func isLastItem(_ item: Source) -> Bool {
        sources.last == item
    }
}

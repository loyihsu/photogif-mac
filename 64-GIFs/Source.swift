//
//  Source.swift
//  64-GIFs
//
//  Created by Loyi on 2020/5/17.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

struct Source: Identifiable, Equatable {
    var id: Int

    var location: String
    var length: String

    var nsImage: NSImage

    var removed: Bool = false
}

extension Array where Element == Source {
    func firstIndex(of element: Element) -> Int? {
        return self.firstIndex(where: { $0.id == element.id })
    }
}

func clear(_ sources: inout [Source]) {
    var output = sources
    for index in 0..<output.count {
        output[index].removed = true
    }
    sources = output
}

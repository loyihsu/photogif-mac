//
//  FileHelper.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import Cocoa

final class FileHelper {
    static let shared = FileHelper()

    func getBundleFileString(named name: String, extension ext: String) -> String? {
        let bundle = Bundle(for: FileHelper.self)
        let url = bundle.url(forResource: name, withExtension: ext)
        return url.flatMap { try? String(contentsOf: $0, encoding: .utf8) }
    }

    func getBundleFile(named name: String, extension ext: String) -> Data? {
        let bundle = Bundle(for: FileHelper.self)
        let url = bundle.url(forResource: name, withExtension: ext)
        return url.flatMap { try? Data(contentsOf: $0) }
    }

    func getBundleNsImage(named name: String, extension ext: String) -> NSImage? {
        let fileContent = getBundleFile(named: name, extension: ext)
        return fileContent.flatMap { NSImage(data: $0) }
    }

    func getTempFile(named name: String) -> Data? {
        let tempUrl = NSTemporaryDirectory()
        let filePath = "file://" + tempUrl + "\(name)"
        return try? Data(contentsOf: URL(string: filePath)!)
    }
}

//
//  ContentView + DropDelegate.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/10/19.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

extension ContentView: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: ["public.file-url"]) {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                if let data = urlData as? Data,
                   let url = URL.init(dataRepresentation: data, relativeTo: nil) {
                    if acceptableTypes.contains(url.pathExtension.lowercased()) {
                        DispatchQueue.main.async {
                            sourceList.append(url)
                        }
                    } else {
                        self.handleDirectoryURL(url)
                    }
                }
            }
        }
        return true
    }
    
    func handleDirectoryURL(_ url: URL) {
        if let directoryContents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) {
            for dir in directoryContents where acceptableTypes.contains(dir.pathExtension.lowercased()) {
                sourceList.append(dir)
            }
        }
    }
}

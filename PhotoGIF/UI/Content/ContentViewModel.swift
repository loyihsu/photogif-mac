//
//  ContentViewModel.swift
//  PhotoGIF
//
//  Created by Loyi on 2020/10/18.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa

class ContentViewModel: ObservableObject {
    // MARK: - Models
    enum GenerateState {
        case success
        case failure
        case loading

        var string: String {
            switch self {
            case .success:
                return "✅"
            case .failure:
                return "❌"
            case .loading:
                return "🏃‍♀️"
            }
        }
    }

    // MARK: - Properties

    @Published var filename: String = "output"

    @Published private(set) var sources = [Source]()
    @Published private(set) var outputPath = NSSearchPathForDirectoriesInDomains(
        .downloadsDirectory,
        .userDomainMask,
        true
    )[0]
    @Published private(set) var generateState: GenerateState? = nil

    private let gifFactory: GIFFactory

    var displayOutputPath: String { self.outputPath.lastFileElement() }

    var canGenerate: Bool {
        let hasSources = !self.sources.isEmpty
        let hasEmptyLengthSource = self.sources.contains(where: { $0.length.isEmpty == true })
        let hasInvalidLengthSource = self.sources.contains { !$0.hasValidLength }
        return hasSources && !hasEmptyLengthSource && !hasInvalidLengthSource && self.generateState != .loading
    }

    init(gifFactory: any GIFFactory = DefaultGIFFactory()) {
        self.gifFactory = gifFactory
    }

    /// Initialise with existing `[Source]`.
    init(gifFactory: any GIFFactory = DefaultGIFFactory(), sources: [Source]) {
        self.gifFactory = gifFactory
        self.sources = sources
    }

    // MARK: - Source Management

    /// Append items to the list.
    func appendSource(_ item: URL) {
        guard Source.supportedTypes.contains(item.pathExtension.lowercased()) else { return }

        guard let image = NSImage(contentsOf: item) else { return }

        let str = item.absoluteString.components(separatedBy: "file://").joined()

        DispatchQueue.main.async {
            self.sources.append(Source(location: str, length: "1", nsImage: image))
        }
    }

    /// Append a list of sources `URL`.
    func appendSources(_ array: [URL]) {
        for item in array {
            self.appendSource(item)
        }
    }

    /// The method to remove an item from the `sources` array.
    func remove(_ item: Source) {
        guard let index = sources.firstIndex(of: item) else { return }
        DispatchQueue.main.async {
            self.sources.remove(at: index)
        }
    }

    /// The method to remove all the items in the `sources` array.
    func removeAllSources() {
        DispatchQueue.main.async {
            self.sources.removeAll()
        }
    }
    
    func moveUp(_ item: Source) {
        guard let idx = sources.firstIndex(of: item) else { return }

        guard idx != 0 else { return }

        // TODO: Use async-await

        DispatchQueue.main.async { [self] in
            let left = idx - 1
            let right = idx
            (self.sources[left], self.sources[right]) = (self.sources[right], self.sources[left])
        }
    }

    func moveDown(_ item: Source) {
        guard let idx = sources.firstIndex(of: item) else { return }

        guard idx + 1 < self.sources.count else { return }

        // TODO: Use async-await

        DispatchQueue.main.async { [self] in
            let left = idx
            let right = idx + 1
            (self.sources[left], self.sources[right]) = (self.sources[right], self.sources[left])
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

    // MARK: - Controls

    /// Function to ouput document and append item into the `FileList`.
    /// - parameter list: The `FileList` containing the `[Source]` list.
    func openDocument() {
        let panel = NSOpenPanel()

        panel.allowsMultipleSelection = true
        panel.allowedFileTypes = Source.supportedTypes

        let result = panel.runModal()

        if result == .OK {
            self.appendSources(panel.urls)
        }
    }

    func selectPath() {
        guard let selected = selectPath() else { return }
        self.outputPath = selected
    }

    /// Function to call the NSOpenPanel to select output path.
    private func selectPath() -> String? {
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

    func generate() {
        self.generateState = .loading

        DispatchQueue.global(qos: .userInteractive).async {
            let isSuccess = self.gifFactory.make(
                with: self.sources,
                path: self.outputPath,
                filename: self.filename
            )

            DispatchQueue.main.async {
                self.generateState = isSuccess ? .success : .failure
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.generateState = nil
            }
        }
    }

    private func strippedFilename() -> String {
        self.filename.components(separatedBy: ".gif").joined()
    }
}

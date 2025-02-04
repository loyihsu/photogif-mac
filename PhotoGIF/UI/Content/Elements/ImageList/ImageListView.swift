//
//  ImageListView.swift
//  PhotoGIF
//
//  Created by Yu-Sung Loyi Hsu on 2025/2/5.
//  Copyright © 2025 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UniformTypeIdentifiers

struct ImageListView: View {
    var store: StoreOf<ImageListFeature>

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(LocalizedStringKey("import")) {
                    self.store.send(.importDocument)
                }
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    Spacer()

                    ForEach(self.store.fileList.sources) { item in
                        HStack {
                            Image(nsImage: item.nsImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)

                            Text(item.displayName)

                            TextField(
                                LocalizedStringKey("seconds"),
                                text: Binding(
                                    get: { item.length },
                                    set: {
                                        self.store.send(.edit(item: item, value: $0))
                                    }
                                )
                            )

                            if !item.hasValidLength {
                                Text("❌")
                            }

                            Text(
                                Int(item.length) ?? 2 == 1
                                    ? LocalizedStringKey("second")
                                    : LocalizedStringKey("seconds")
                            )

                            Button("✘") {
                                self.store.send(.remove(item: item))
                            }
                            Button("⬆") {
                                self.store.send(.moveUp(item: item))
                            }
                            .disabled(self.store.fileList.isFirstSource(item))

                            Button("⬇") {
                                self.store.send(.moveDown(item: item))
                            }
                            .disabled(self.store.fileList.isLastSource(item))
                        }
                    }

                    if !self.store.fileList.sources.isEmpty {
                        Button(LocalizedStringKey("clear")) {
                            self.store.send(.removeAllSources)
                        }
                    }
                }
                .padding(20)
            }
        }
        .onDrop(of: ["public.file-url"], delegate: self)
        .frame(width: 480, height: 360, alignment: .topLeading)
        .padding()
    }
}

extension ImageListView: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: ["public.file-url"]) {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { urlData, error in
                if let data = urlData as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil)
                {
                    if Source.supportedTypes.contains(UTType(filenameExtension: url.pathExtension.lowercased())!) {
                        self.store.send(.filesSelected(urls: [url]))
                    } else {
                        self.handleDirectoryURL(url)
                    }
                }
            }
        }
        return true
    }

    func handleDirectoryURL(_ url: URL) {
        guard let directoryContents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else { return }

        let urls = directoryContents
            .filter {
                Source.supportedTypes.contains(UTType(filenameExtension: $0.pathExtension.lowercased())!)
            }

        self.store.send(.filesSelected(urls: urls))
    }
}

#Preview {
    ImageListView(
        store: StoreOf<ImageListFeature>(
            initialState: ImageListFeature.State(),
            reducer: {
                ImageListFeature()
            }
        )
    )
}

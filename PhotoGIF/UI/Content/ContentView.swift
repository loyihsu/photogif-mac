//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Perception.Bindable var store: StoreOf<ContentFeature>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                self.imageList()
                self.controls()
            }
        }
    }

    private func imageList() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .center) {
                Spacer()
                Button(LocalizedStringKey("import")) {
                    self.store.send(.openDocument)
                }
                ForEach(self.store.fileList.sources) { item in
                    HStack {
                        // Preview Image
                        Image(nsImage: item.nsImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)

                        Text(item.displayName)

                        // TextField
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
                    .frame(width: 460, height: 50)
                }

                // Clear list
                if !self.store.fileList.sources.isEmpty {
                    Button(LocalizedStringKey("clear")) {
                        self.store.send(.removeAllSources)
                    }
                }
            }
            .frame(width: 480)
        }
        .onDrop(of: ["public.file-url"], delegate: self)
        .frame(width: 480, height: 360, alignment: .topLeading)
        .padding()
    }

    private func controls() -> some View {
        Group {
            VStack {
                HStack {
                    Text("🗂 \(self.store.displayOutputPath)")
                    Button(LocalizedStringKey("change")) {
                        self.store.send(.selectPath)
                    }
                }

                HStack {
                    Text(LocalizedStringKey("filename"))
                    TextField(
                        LocalizedStringKey("filename"),
                        text: self.$store.outputFilename
                    )
                    .frame(width: 135, height: 12, alignment: .center)
                }
            }

            HStack {
                Button(LocalizedStringKey("generate")) {
                    self.store.send(.generate)
                }
                .disabled(!self.store.canGenerate)
                Text(self.store.generationState?.string ?? "")
            }
            .padding()
        }
    }
}

extension ContentView: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: ["public.file-url"]) {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { urlData, error in
                if let data = urlData as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil)
                {
                    if Source.supportedTypes.contains(url.pathExtension.lowercased()) {
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
                Source.supportedTypes.contains($0.pathExtension.lowercased())
            }

        self.store.send(.filesSelected(urls: urls))
    }
}

private extension ContentFeature.State.GenerationState {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView(
            store: StoreOf<ContentFeature>(
                initialState: ContentFeature.State(),
                reducer: {
                    ContentFeature()
                }
            )
        )
    }
}

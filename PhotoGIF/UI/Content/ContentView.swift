//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            self.imageList()
            self.controls()
        }
    }

    private func imageList() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .center) {
                Spacer()
                Button(LocalizedStringKey("import")) {
                    self.viewModel.openDocument()
                }
                ForEach(self.viewModel.sources) { item in
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
                                set: { self.viewModel.edit(item, with: $0) }
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
                            self.viewModel.remove(item)
                        }
                        Button("⬆") {
                            self.viewModel.move(item, dir: .up)
                        }
                        .disabled(self.viewModel.isFirstSource(item))

                        Button("⬇") {
                            self.viewModel.move(item, dir: .down)
                        }
                        .disabled(self.viewModel.isLastSource(item))
                    }
                    .frame(width: 460, height: 50)
                }

                // Clear list
                if !self.viewModel.sources.isEmpty {
                    Button(LocalizedStringKey("clear")) {
                        self.viewModel.removeAllSources()
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
                    Text("🗂 \(self.viewModel.displayOutputPath)")
                    Button(LocalizedStringKey("change")) {
                        self.viewModel.selectPath()
                    }
                }

                HStack {
                    Text(LocalizedStringKey("filename"))
                    TextField(LocalizedStringKey("filename"), text: self.$viewModel.filename)
                        .frame(width: 135, height: 12, alignment: .center)
                }
            }

            HStack {
                Button(LocalizedStringKey("generate")) {
                    self.viewModel.generate()
                }
                .disabled(!self.viewModel.canGenerate)
                Text(self.viewModel.generateState?.string ?? "")
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
                        self.viewModel.appendSource(url)
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
            for dir in directoryContents where Source.supportedTypes.contains(dir.pathExtension.lowercased()) {
                viewModel.appendSource(dir)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}

//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

struct ContentView: View, DropDelegate {
    @ObservedObject var sourceList = FileList()
    @State var outputPath: String = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
    @State var filename: String = "output"
    @State var generateState: String = ""
    
    var protectNumOnly: Bool { sourceList.sources.filter { validate($0.length) }.count > 0 }
    var protectEmpty: Bool { sourceList.sources.filter { $0.length.isEmpty == true }.count > 0 }
    
    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: ["public.file-url"]) {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                if let data = urlData as? Data,
                   let url = URL.init(dataRepresentation: data, relativeTo: nil) {
                    if acceptableTypes.contains(url.pathExtension.lowercased()) {
                        sourceList.append(url)
                    } else {
                        self.handleDirectoryURL(url)
                    }
                }
            }
        }
        
        return true
    }
    
    func handleDirectoryURL(_ url: URL) {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for dir in directoryContents {
                if acceptableTypes.contains(dir.pathExtension.lowercased()) {
                    sourceList.append(dir)
                }
            }
        } catch { }
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    HStack{ Spacer() }
                    Button("Import Image(s)") {
                        openDocument(list: sourceList)
                    }
                    ForEach(sourceList.sources) { item in
                        HStack {
                            // Preview Image
                            Image(nsImage: item.nsImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                            Text(item.displayName)
                            
                            // TextField
                            TextField("seconds",
                                      text: Binding<String>(get: { item.length },
                                                            set: { newValue in
                                                                sourceList.edit(item, with: newValue)
                                                            }))
                            Text(Int(item.length) ?? 2 == 1 ? "second" : "seconds")
                            if validate(item.length) == false { Text("❌") }
                            
                            // Controls
                            Button("✘") {
                                sourceList.remove(item)
                            }
                            Button("⬆") {
                                sourceList.move(item, dir: true)
                            }
                            .disabled(sourceList.isFirstItem(item))
                            Button("⬇") {
                                sourceList.move(item, dir: false)
                            }
                            .disabled(sourceList.isLastItem(item))
                        }
                        .frame(width: 460, height: 50)
                    }
                    // Clear list
                    if sourceList.count != 0 {
                        Button("Clear") {
                            sourceList.removeAll()
                        }
                    }
                }
            }
            .onDrop(of: ["public.file-url"], delegate: self)
            .frame(width: 480, height: 360, alignment: .topLeading)
            .padding()
            
            // Output and Generate Controls
            VStack {
                HStack {
                    Text("🗂 \(outputPath.lastElement())")
                    Button("Change Output Path") {
                        if let selected = selectPath() {
                            self.outputPath = selected
                        }
                    }
                }
                
                HStack {
                    Text("Output Filename")
                    TextField("Output Filename", text: $filename)
                        .frame(width: 135, height: 12, alignment: .center)
                }
            }
            
            HStack {
                Button("Generate") {
                    let items = sourceList.sources
                    let success = generateGIF(from: items.map { $0.nsImage },
                                              delays: items.map { Double($0.length)! },
                                              docDirPath: self.outputPath,
                                              filename: "/\(formatFilename(self.filename)).gif"
                    )
                    self.generateState = success ? "✅" : "❌"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.generateState = ""
                    }
                    
                }
                .disabled(sourceList.count == 0 || !protectNumOnly || protectEmpty)
                Text(generateState)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}

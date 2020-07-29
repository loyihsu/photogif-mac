//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

var inputCount = 0
let acceptableTypes = ["jpeg", "jpg", "png", "ai", "bmp", "tif", "tiff", "heic", "psd"]

struct ContentView: View, DropDelegate {
    @State var sources: [Source] = []
    @State var outputPath: String = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
    @State var filename: String = "output"
    @State var generateState: String = ""
    
    //    var restingItems: [Source] { sources.filter { $0.removed == false } }
    var count: Int { sources.count }
    
    var protectNumOnly: Bool { sources.filter { validate($0.length) }.count > 0 }
    var protectEmpty: Bool { sources.filter { $0.length.isEmpty == true }.count > 0}
    
    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: ["public.file-url"]) {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                if let data = urlData as? Data,
                   let url = URL.init(dataRepresentation: data, relativeTo: nil) {
                    if acceptableTypes.contains(url.pathExtension.lowercased()) {
                        append(url, to: &self.sources)
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
                    append(dir, to: &self.sources)
                }
            }
        } catch {
            
        }
    }
    
    func moveItem(dir: String, i: Source) {
        let index = self.sources.firstIndex(of: i)!
        let newIndex: Int = dir == "up" ? index - 1 : index + 1
        
        if newIndex >= 0 && newIndex < sources.count {
            let temp = sources[index]
            sources[index] = sources[newIndex]
            sources[newIndex] = temp
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    HStack{ Spacer() }
                    Button("Import Image(s)") {
                        openDocument(&self.sources)
                    }
                    ForEach(sources) { i in
                        HStack {
                            // Image & Preview
                            Image(nsImage: i.nsImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                            Text(i.location.lastElement())
                            
                            // TextField
                            TextField("seconds",
                                      text: self.$sources[self.sources.firstIndex(of: i)!].length)
                            Text(Int(i.length) ?? 2 == 1 ? "second" : "seconds")
                            if validate(i.length) == false { Text("❌") }
                            
                            // Controls
                            Button("✘") {
                                let id = self.sources.firstIndex(of: i)!
                                self.sources.remove(at: id)
                            }
                            Button("⬆") {
                                self.moveItem(dir: "up", i: i)
                            }
                            .disabled(i == self.sources.first!)
                            Button("⬇") {
                                self.moveItem(dir: "down", i: i)
                            }
                            .disabled(i == self.sources.last!)
                        }
                        .frame(width: 460, height: 50)
                    }
                    // Clear list
                    if count != 0 {
                        Button("Clear") {
                            while !sources.isEmpty {
                                sources.removeLast()
                            }
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
                    let items = self.sources
                    
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
                .disabled(count == 0 || !protectNumOnly || protectEmpty)
                Text(generateState)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //        let listOfItems: [String] = [
        //
        //        ]
        //
        //        var sourceList = [Source]()
        //
        //        for (index, item) in listOfItems.enumerated() {
        //
        //            if let url = URL.init(string: item),
        //                let image = NSImage.init(contentsOf: url) {
        //                let newitem = Source.init(id: index,
        //                                          location: item,
        //                                          length: "1",
        //                                          nsImage: image)
        //                sourceList.append(newitem)
        //            }
        //        }
        //
        //        return ContentView(sources: sourceList)
        return ContentView()
    }
}

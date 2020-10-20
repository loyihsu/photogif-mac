//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sourceList = FileList()
    
    @State var outputPath: String = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
    @State var filename: String = "output"
    @State var generateState: String = ""

    var hasEmpty: Bool { sourceList.sources.filter { $0.length.isEmpty == true }.count > 0 }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    HStack{ Spacer() }
                    Button(NSLocalizedString("import", comment: "Import Image(s) button.")) {
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
                            TextField(NSLocalizedString("seconds", comment: "second (plural)"),
                                      text: Binding<String>(get: { item.length },
                                                            set: { newValue in
                                                                sourceList.edit(item, with: generateAcceptableOnly(newValue))
                                                            }))
                            if !validate(item.length) {
                                Text("❌")
                            }
                            Text(Int(item.length) ?? 2 == 1 ? NSLocalizedString("second", comment: "second (singular)") : NSLocalizedString("seconds", comment: "second (plural)"))
                            
                            // Controls
                            Button("✘") { sourceList.remove(item) }
                            Button("⬆") { sourceList.move(item, dir: true) }.disabled(sourceList.isFirstItem(item))
                            Button("⬇") { sourceList.move(item, dir: false) }.disabled(sourceList.isLastItem(item))
                        }
                        .frame(width: 460, height: 50)
                    }
                    // Clear list
                    if sourceList.count != 0 {
                        Button(NSLocalizedString("Clear", comment: "Clear button to clear all imported images.")) {
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
                    Button(NSLocalizedString("change", comment: "Button to change output paths.")) {
                        if let selected = selectPath() {
                            self.outputPath = selected
                        }
                    }
                }
                
                HStack {
                    Text(NSLocalizedString("filename", comment: "Label for output filename input."))
                    TextField(NSLocalizedString("filename", comment: "Label for output filename input."), text: $filename)
                        .frame(width: 135, height: 12, alignment: .center)
                }
            }
            
            HStack {
                Button(NSLocalizedString("generate", comment: "Button to generate output file.")) {
                    let items = sourceList.sources
                    let success = generateGIF(from: items.map { $0.nsImage },
                                              delays: items.map { Double($0.length)! },
                                              docDirPath: self.outputPath,
                                              filename: "/\(formatFilename(self.filename)).gif")
                    self.generateState = success ? "✅" : "❌"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.generateState = ""
                    }
                }
                .disabled(sourceList.count == 0 || hasEmpty || sourceList.sources.filter { !validate($0.length) }.count != 0 )
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

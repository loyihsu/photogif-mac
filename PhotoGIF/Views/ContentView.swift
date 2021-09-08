//
//  ContentView.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sourceList = FileList()
    
    @State var outputPath: String = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
    @State var filename: String = "output"
    @State var generateState: String = ""

    var hasEmpty: Bool { sourceList.sources.contains { $0.length.isEmpty == true }}

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    HStack{ Spacer() }
                    Button(LocalizedStringKey("import")) {
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
                            TextField(LocalizedStringKey("seconds"),
                                      text: Binding<String>(get: { item.length },
                                                            set: { newValue in
                                                                sourceList.edit(item, with: generateAcceptableOnly(newValue))
                                                            }))
                            if !validate(item.length) || item.length.isEmpty {
                                Text("❌")
                            }
                            Text(Int(item.length) ?? 2 == 1 ? LocalizedStringKey("second") : LocalizedStringKey("seconds"))
                            
                            // Controls
                            Button("✘") {
                                sourceList.remove(item)
                            }
                            Button("⬆") { sourceList.move(item, dir: .up) }.disabled(sourceList.isFirstItem(item))
                            Button("⬇") { sourceList.move(item, dir: .down) }.disabled(sourceList.isLastItem(item))
                        }
                        .frame(width: 460, height: 50)
                    }
                    // Clear list
                    if sourceList.count != 0 {
                        Button(LocalizedStringKey("clear")) {
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
                    Button(LocalizedStringKey("change")) {
                        if let selected = selectPath() {
                            self.outputPath = selected
                        }
                    }
                }
                
                HStack {
                    Text(LocalizedStringKey("filename"))
                    TextField(LocalizedStringKey("filename"), text: $filename)
                        .frame(width: 135, height: 12, alignment: .center)
                }
            }
            
            HStack {
                Button(LocalizedStringKey("generate")) {
                    let items = sourceList.sources
                    let success = generateGIF(from: items.map { $0.nsImage },
                                              delays: items.map { Double($0.length)! },
                                              path: self.outputPath,
                                              filename: "/\(formatFilename(self.filename)).gif")
                    self.generateState = success ? "✅" : "❌"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.generateState = ""
                    }
                }
                .disabled(sourceList.count == 0 || hasEmpty || sourceList.sources.contains { !validate($0.length) } )
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

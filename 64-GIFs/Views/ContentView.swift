//
//  ContentView.swift
//  64-GIFs
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

var inputCount = 0

let acceptableFileExt = "public.file-url"

struct ContentView: View, DropDelegate {
    @State var sources: [Source] = []
    @State var outputPath: String = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
    @State var filename: String = "output"
    @State var generateState: String = ""
    var restingItems: [Source] { sources.filter { $0.removed == false } }
    var count: Int { restingItems.count }

    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: [acceptableFileExt]) {
            item.loadItem(forTypeIdentifier: acceptableFileExt, options: nil) { (urlData, error) in
                if let data = urlData as? Data, let url = URL.init(dataRepresentation: data, relativeTo: nil) {
                    append(url, to: &self.sources)
                    //print(url.absoluteString)
                }
            }
        }

        return true
    }

    func moveItem(dir: String, i: Source) {
        let index = self.sources.firstIndex(of: i)!
        var newIndex: Int = 0
        var flag = false
        if dir == "up" {
            var temp = index - 1

            while temp >= 0 {
                if self.sources[temp].removed == false {
                    newIndex = temp
                    flag = true
                    break
                }
                temp -= 1
            }

            if flag == false { return }
        } else {
            for i in index+1..<self.sources.count {
                if self.sources[i].removed == false {
                    newIndex = i
                    flag = true
                    break
                }
            }

            if flag == false { return }
        }

        if index != newIndex {
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
                        if !i.removed {
                            HStack {
                                Image(nsImage: i.nsImage).resizable()
                                    .frame(width: 32, height: 32)

                                Text(i.location.lastElement())

                                TextField("seconds",
                                          text: self.$sources[self.sources.firstIndex(of: i)!].length)
                                #warning("TODO: Only accept numbers & no negatives")

                                Text(Int(i.length) ?? 2 == 1 ? "second" : "seconds")

                                Button("✘") {
                                    self.sources[self.sources.firstIndex(of: i)!].removed = true
                                }

                                Button("⬆") {
                                    self.moveItem(dir: "up", i: i)
                                }
                                .disabled(i == self.restingItems.first!)

                                Button("⬇") {
                                    self.moveItem(dir: "down", i: i)
                                }
                                .disabled(i == self.restingItems.last!)
                            }
                            .frame(width: 480, height: 50)
                        }
                    }
                    if count != 0 {
                        Button("Clear") {
                            clear(&self.sources)
                        }
                    }
                }
            }
            .onDrop(of: [acceptableFileExt], delegate: self)
            .frame(width: 480, height: 360, alignment: .topLeading)
            .padding()

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
                    let items = self.sources.filter { $0.removed == false }
                    
                    let success = generateGIF(from: items.map {
                        NSImage(contentsOfFile: $0.location)!
                        }, delays: items.map { Double($0.length)! },
                           docDirPath: self.outputPath,
                           filename: "/\(formatFilename(self.filename)).gif"
                    )

                    self.generateState = success ? "✅" : "❌"

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.generateState = ""
                    }

                }
                .disabled(count == 0)
                Text(generateState)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let listOfItems: [String] = [

        ]
        
        var sourceList = [Source]()
        var count = 0
        
        for item in listOfItems {
            let newitem = Source.init(id: count,
                                      location: item,
                                      length: "1",
                                      nsImage: NSImage.init(contentsOf: URL(string: item)!)!)
            sourceList.append(newitem)
            count += 1
        }
        
        return ContentView(sources: sourceList)
    }
}

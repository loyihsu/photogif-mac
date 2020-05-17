//
//  ContentView.swift
//  64-GIFs
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

extension String {
    func lastElement() -> String {
        return self.components(separatedBy: "/").filter { $0.isEmpty == false }.last ?? "Image"
    }
}

var inputCount = 0

func formatFilename(_ str: String) -> String {
    return str.components(separatedBy: ".gif").joined()
}

struct ContentView: View, DropDelegate {
    @State var sources: [Source] = []
    @State var outputPath: String = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
    @State var filename: String = "output"
    var restingItems: [Source] { sources.filter { $0.removed == false } }
    var count: Int { restingItems.count }

    func performDrop(info: DropInfo) -> Bool {
        for item in info.itemProviders(for: ["public.file-url"]) {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                if let data = urlData as? Data, let url = URL.init(dataRepresentation: data, relativeTo: nil) {
                    append(url, to: &self.sources)
                    //print(url.absoluteString)
                }
            }
        }

        return true
    }

    func clear() {
        var output = sources
        for index in 0..<output.count {
            output[index].removed = true
        }
        sources = output
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
                                Text("seconds")

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
                            self.clear()
                        }
                    }
                }
            }
            .onDrop(of: ["public.file-url"], delegate: self)
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
                    
                    print("Success: \(success)")
                }
                .padding()
                .disabled(count == 0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let listOfItems = [
            "/Users/loyihsu/Downloads/others/aa/01.png",
            "/Users/loyihsu/Downloads/others/aa/02.png",
            "/Users/loyihsu/Downloads/others/aa/03.png"
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

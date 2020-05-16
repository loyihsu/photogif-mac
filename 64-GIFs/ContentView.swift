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
        return self.components(separatedBy: "/").last ?? "Image"
    }
}

let outputPath = "/Users/loyihsu/Downloads/aa/" // For testing

struct Source: Identifiable, Equatable {
    var id: Int
    
    var location: String
    var length: String
    var removed: Bool = false
}

extension Array where Element == Source {
    func firstIndex(of element: Element) -> Int? {
        return self.firstIndex(where: { $0.id == element.id })
    }
}

var inputCount = 0

struct ContentView: View {
    @State var sources: [Source] = []
    var restingItems: [Source] { sources.filter { $0.removed == false } }
    var count: Int { restingItems.count }


    func openDocument() {
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = true
        
        let result = panel.runModal()
        if result == .OK {
            for url in panel.urls {
                var str = url.absoluteString
                str = str.components(separatedBy: "file://").joined()
                
                self.sources.append(Source.init(
                    id: inputCount,
                    location: str,
                    length: "1")
                )
                
                inputCount += 1
            }
        }
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
                VStack {
                    ForEach(sources) { i in
                        if !i.removed {
                            HStack {
                                Image(nsImage: NSImage(contentsOfFile: i.location)!).resizable()
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

                    // Drag & Drop
                }
            }
            .frame(width: 480, height: 360, alignment: .topLeading)
            .padding()
            
            HStack {
                Button("Generate") {
                    let items = self.sources.filter { $0.removed == false }
                    
                    let success = generateGIFs(from: items.map {
                        NSImage(contentsOfFile: $0.location)!
                        }, delays: items.map { Double($0.length)! },
                           docDirPath: outputPath,
                           filename: "/test.gif"
                    )
                    
                    print("Success: \(success)")
                }
                .padding()
                .disabled(count == 0)
                
                Button("Open Document(s)") {
                    self.openDocument()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let listOfItems = [
            "/Users/loyihsu/Downloads/aa/01.png",
            "/Users/loyihsu/Downloads/aa/02.png",
            "/Users/loyihsu/Downloads/aa/03.png"
        ]
        
        var sourceList = [Source]()
        var count = 0
        
        for item in listOfItems {
            let newitem = Source.init(id: count,
                                      location: item,
                                      length: "1")
            sourceList.append(newitem)
            count += 1
        }
        
        return ContentView(sources: sourceList)
    }
}

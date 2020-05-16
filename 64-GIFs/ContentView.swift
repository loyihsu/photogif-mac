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

struct Source: Identifiable {
    var id: Int
    
    var location: String
    var length: String
}

var inputCount = 0

struct ContentView: View {
    @State var sources: [Source] = []
    
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
        self.sources = []
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(sources) { i in
                        HStack {
                            Image(nsImage: NSImage(contentsOfFile: i.location)!).resizable()
                                .frame(width: 32, height: 32)
                            
                            Text(i.location.lastElement())
                            
                            #warning("index out of range error")
                            TextField("seconds",
                                      text: self.$sources[self.sources.firstIndex(where: { $0.id == i.id })!].length)
                            Text("seconds")
                            
                            Button("Remove") {
                                self.sources.remove(at: self.sources.firstIndex(where: { $0.id == i.id })!)
                            }
                        }
                        .frame(width: 480, height: 50)
                    }
                    // Drag & Drop
                }
            }
            .frame(width: 480, height: 360, alignment: .topLeading)
            .padding()
            
            HStack {
                Button("Generate") {
                    let items = self.sources
                    
                    let success = generateGIFs(from: items.map {
                        NSImage(contentsOfFile: $0.location)!
                        }, delays: items.map { Double($0.length)! },
                           docDirPath: outputPath,
                           filename: "/test.gif"
                    )
                    
                    print("Success: \(success)")
                    
                    //self.sources.forEach { print($0.length) }
                }
                .padding()
                
                Button("Open Document") {
                    self.openDocument()
                    
                }
                Button("Clear") {
                    self.clear()
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

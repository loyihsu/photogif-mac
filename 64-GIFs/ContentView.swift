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

struct ContentView: View {
    @State var sources: [Source] = []
    
    func removeRows(at offsets: IndexSet) {
        sources.remove(atOffsets: offsets)
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
                            
                            TextField("seconds", text: self.$sources[self.sources.firstIndex(where: { $0.id == i.id })!].length)
                            Text("seconds")
                            
                            Button("Remove") {
                                self.sources.remove(at: self.sources.firstIndex(where: {
                                    $0.id == i.id
                                })!)
                            }
                        }
                        .frame(width: 480, height: 50)
                    }
                    .onDelete(perform: removeRows)
                    // Drag & Drop
                }
            }
            .frame(width: 480, height: 360, alignment: .topLeading)
            .padding()
            
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

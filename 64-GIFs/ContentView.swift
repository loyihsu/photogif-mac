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

struct ContentView: View {
    @State var sources: [String] = []
    @State var length: [String] = []
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    
                    // Current implementation cannot handle remove events
                    // Suggestion is to change it to id-based ForEach
                    // Or find a way to access it from within
                    
                    // Drag & Drop
                    
                    ForEach(0..<sources.count) { index in
                        HStack {
                            Image.init(nsImage: NSImage.init(contentsOfFile: self.sources[index])!).resizable()
                                .frame(width: 32, height: 32)
                            
                            Text(self.sources[index].lastElement())
                
                            TextField("Seconds", text: self.$length[index])
                            Text("Seconds")
                            
                            Button.init("Remove") {
                                //self.sources.remove(at: index)
                                //self.length.remove(at: index)
                            }
                        }
                        .frame(width: 480, height: 50)
                    }
                }
            }
            .frame(width: 480, height: 360, alignment: .topLeading)
            .padding()
            
            Button("Generate") {
                if generateGIFs(from: self.sources.map { NSImage.init(contentsOfFile: $0)! }, delays: self.length.map { Double($0)! }, docDirPath: outputPath, filename: "/test.gif") {
                    print("Success")
                } else {
                    print("Failed")
                }
            }
            .padding()
            
            // Right: add button
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        ContentView.init(sources: [
            "/Users/loyihsu/Downloads/aa/01.png",
            "/Users/loyihsu/Downloads/aa/02.png",
            "/Users/loyihsu/Downloads/aa/03.png"
        ], length: [ "1", "1", "1" ])
    }
}

//struct ContentView_Previews_Empty: PreviewProvider {
//    static var previews: some View {
//        ContentView.init()
//    }
//}

//struct ContentView_Previews_Long: PreviewProvider {
//    static var previews: some View {
//
//        ContentView.init(sources: [
//            "/Users/loyihsu/Downloads/aa/01.png",
//            "/Users/loyihsu/Downloads/aa/02.png",
//            "/Users/loyihsu/Downloads/aa/03.png",
//            "/Users/loyihsu/Downloads/aa/01.png",
//            "/Users/loyihsu/Downloads/aa/02.png",
//            "/Users/loyihsu/Downloads/aa/03.png",
//            "/Users/loyihsu/Downloads/aa/01.png",
//            "/Users/loyihsu/Downloads/aa/02.png",
//            "/Users/loyihsu/Downloads/aa/03.png",
//            "/Users/loyihsu/Downloads/aa/01.png",
//            "/Users/loyihsu/Downloads/aa/02.png",
//            "/Users/loyihsu/Downloads/aa/03.png"
//        ], length: [ "1", "1", "1","1", "1", "1","1", "1", "1","1", "1", "1" ])
//    }
//}

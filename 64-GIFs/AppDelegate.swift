//
//  AppDelegate.swift
//  64-GIFs
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        
//        let listOfItems = [
//            "/Users/loyihsu/Downloads/aa/01.png",
//            "/Users/loyihsu/Downloads/aa/02.png",
//            "/Users/loyihsu/Downloads/aa/03.png"
//        ]
//
//        var sourceList = [Source]()
//        var count = 0
//
//        for item in listOfItems {
//            let newitem = Source.init(id: count,
//                                      location: item,
//                                      length: "1")
//            sourceList.append(newitem)
//            count += 1
//        }
//
//        let contentView = ContentView.init(sources: sourceList)
        
        let contentView = ContentView()
        
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        window.titlebarAppearsTransparent = true
        
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


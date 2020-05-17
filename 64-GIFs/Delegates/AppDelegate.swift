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
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var window: NSWindow!
    var aboutWindow = NSWindow()

    var aboutWindowAppeared = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        
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

    @IBAction func callCustomisedAboutView(_ caller: NSMenuItem) {
        if aboutWindowAppeared == false {
            let aboutView = AboutView()

            aboutWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                styleMask: [.titled, .closable, .fullSizeContentView],
                backing: .buffered, defer: false)

            aboutWindow.titlebarAppearsTransparent = true

            aboutWindow.center()
            aboutWindow.setFrameAutosaveName("About Window")
            aboutWindow.contentView = NSHostingView(rootView: aboutView)
            aboutWindow.makeKeyAndOrderFront(nil)

            aboutWindow.delegate = self
            aboutWindowAppeared = true
        } else {
            aboutWindow.makeKeyAndOrderFront(nil)
        }
    }

    func windowWillClose(_ notification: Notification) {
        aboutWindowAppeared = false
    }
}

//
//  AppDelegate.swift
//  PhotoGIF
//
//  Created by Loyi Hsu on 2020/5/15.
//  Copyright © 2020 Loyi Hsu. All rights reserved.
//

import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    var aboutWindow = NSWindow()

    var isAboutWindowAppeared = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        self.window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )

        self.window.titlebarAppearsTransparent = true

        self.window.center()
        self.window.setFrameAutosaveName("Main Window")
        self.window.contentView = NSHostingView(rootView: contentView)
        self.window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func callCustomisedAboutView(_ caller: NSMenuItem) {
        if self.isAboutWindowAppeared {
            self.aboutWindow.makeKeyAndOrderFront(nil)
            return
        }

        let aboutView = AboutView()

        self.aboutWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered, defer: false
        )

        self.aboutWindow.titlebarAppearsTransparent = true

        self.aboutWindow.center()
        self.aboutWindow.setFrameAutosaveName("About Window")
        self.aboutWindow.contentView = NSHostingView(rootView: aboutView)
        self.aboutWindow.makeKeyAndOrderFront(nil)

        self.aboutWindow.delegate = self
        self.isAboutWindowAppeared = true
    }

    func windowWillClose(_ notification: Notification) {
        self.isAboutWindowAppeared = false
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

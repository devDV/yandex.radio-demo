//
//  AppDelegate.swift
//  yandex.radio-demo
//
//  Created by dattk on 03/08/2019.
//  Copyright © 2019 dattk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSLog(#function + flag.description)
        sender.activate(ignoringOtherApps: true)
        if !flag, let window = sender.windows.first {
            window.makeKeyAndOrderFront(self)
        }
        return true
    }
    
    func switchTo(view: NSView) {
        guard let mainView = window.contentView else {return}
        view.frame = mainView.bounds
        view.autoresizesSubviews = true
        view.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
//        oldView?.removeFromSuperview()
        mainView.addSubview(view)
    }

}


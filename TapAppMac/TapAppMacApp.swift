//
//  TapAppMacApp.swift
//  TapAppMac
//
//  Created by Sergej Lotz on 02.07.23.
//

import SwiftUI

var server: Server?

@main
struct TapAppMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
   
    
    
    static private(set) var instance: AppDelegate!
    
    
    
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()

    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.button?.title = "Tap App"
        statusBarItem.menu = menu.createMenu()
        initServer(port: 12345)
    }
    
    
    func initServer(port: UInt16) {
        print("initializedServer0")
        server = Server(port: port)
        print("initializedServer1")
        try! server?.start()
        print("initializedServer2")
    }
    
    

}

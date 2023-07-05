//
//  TapAppMacApp.swift
//  TapAppMac
//
//  Created by Sergej Lotz on 02.07.23.
//

import SwiftUI
import Cocoa
import Network

@main
struct TapAppMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var listener: NWListener?
    
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.button?.title = "LMU PML"
        statusBarItem.menu = menu.createMenu()
        
        startServer()
    }
    func startServer() {
        do {
            listener = try NWListener(using: .tcp, on: 1234) // Replace with the desired port number
            
            listener?.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    print("Server started")
                case .failed(let error):
                    print("Server failed with error: \(error.localizedDescription)")
                default:
                    break
                }
            }
            
            listener?.newConnectionHandler = { newConnection in
                self.handleIncomingConnection(newConnection)
            }
            
            listener?.start(queue: .main)
        } catch {
            print("Failed to start server: \(error.localizedDescription)")
        }
    }
    
    func handleIncomingConnection(_ connection: NWConnection) {
        // Handle incoming connection and data here
        connection.start(queue: .main)
        
        // Example: Receive data
        receiveData(from: connection)
    }
    
    func receiveData(from connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, _, error in
            if let data = data, !data.isEmpty {
                let receivedData = String(data: data, encoding: .utf8)
                print("Received data: \(receivedData ?? "")")
                
                // Process the received data as needed
                
                // Example: Echo the received data back to the client
                connection.send(content: data, completion: .contentProcessed { error in
                    if let error = error {
                        print("Failed to send data with error: \(error.localizedDescription)")
                    } else {
                        // Continue to receive more data
                        self.receiveData(from: connection)
                    }
                })
            } else if let error = error {
                print("Failed to receive data with error: \(error.localizedDescription)")
            } else {
                // Connection closed by the client
                print("Connection closed by the client")
            }
        }
    }
}

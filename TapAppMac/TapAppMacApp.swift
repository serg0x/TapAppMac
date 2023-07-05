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
    var server: Server?
    var listener: NWListener?
    
    static private(set) var instance: AppDelegate!
    lazy var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = ApplicationMenu()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.instance = self
        statusBarItem.button?.title = "LMU PML"
        statusBarItem.menu = menu.createMenu()
        
        // Create and start the server
        server = Server()
        server?.startServer()
        
        // Enable Bonjour service discovery
        startServiceDiscovery()
    }

    func startServiceDiscovery() {
        listener = try? NWListener(using: .tcp, on: 0)
        listener?.stateUpdateHandler = { [weak self] newState in
            switch newState {
            case .ready:
                self?.publishService()
            case .failed(let error):
                print("Service discovery failed with error: \(error.localizedDescription)")
            default:
                break
            }
        }
        listener?.start(queue: .main)
    }
    
    func publishService() {
        guard let port = listener?.port else {
            print("Failed to get the listener port")
            return
        }
        
        let service = NetService(
            domain: "",
            type: "_myapp._tcp",
            name: "MyServer",
            port: 1337
        )
        service.delegate = self
        service.publish()
    }

}
extension AppDelegate: NetServiceDelegate {
    func netServiceDidPublish(_ sender: NetService) {
        print("Service published: \(sender.name)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish service: \(errorDict)")
    }
}

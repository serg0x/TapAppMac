//
//  Server.swift
//  TapAppMac
//
//  Created by Shady Mansour on 06.07.23.
//

import Foundation
import Network

@available(macOS 10.14, *)
class Server : NSObject {
    let port: NWEndpoint.Port
    let listener: NWListener
    private var isConnected: Bool
    private var keepRunning: Bool
    
    private var connectionsByID: [Int: ServerConnection] = [:]

    init(port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        listener = try! NWListener(using: .tcp, on: self.port)
        isConnected = false
        keepRunning = true
        super.init()
        self.registerService()
        
    }

    func start() throws {
        print("Server starting...")
        listener.stateUpdateHandler = self.stateDidChange(to:)
        listener.newConnectionHandler = self.didAccept(nwConnection:)
        listener.start(queue: .main)
    }

    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
          print("Server ready.")
        case .failed(let error):
            print("Server failure, error: \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        default:
            break
        }
    }

    private func didAccept(nwConnection: NWConnection) {
       
        if !isConnected{
            let connection = ServerConnection(nwConnection: nwConnection)
            connection.didStopCallback = { _ in
                self.connectionDidStop(connection)
            }
            connection.start()
            self.connectionsByID[connection.id] = connection
            connection.send(data: "Welcome you are connection: \(connection.id) ".data(using: .utf8)!)
            print("server did open connection \(connection.id)")
            isConnected = true
        }else{
            nwConnection.cancel()
            print("server rejected connection")
        }
    }

    private func connectionDidStop(_ connection: ServerConnection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        print("server did close connection \(connection.id)")
        if(self.connectionsByID.isEmpty){
            isConnected = false
        }
    }

    private func stop() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            connection.stop()
        }
        self.connectionsByID.removeAll()
        self.keepRunning = false
    }
    
    private func registerService() {
        if let ipAddress = extractIPAddress(from: Host.current().addresses) {
            print(ipAddress)
            print(Int32(self.port.rawValue))

            let agent = ServiceAgent()
            let runloop = RunLoop.main
            let service = NetService(domain: "local.", type: "_tapapp._tcp", name: "tapApp", port: Int32(self.port.rawValue))
            service.schedule(in: runloop, forMode: .common)
            service.delegate = agent
            let dictData: [String: Data] = ["ip": ipAddress.data(using: .utf8)!, "port": String(Int32(self.port.rawValue)).data(using: .utf8)!]
            let data = NetService.data(fromTXTRecord: dictData)
            print("set data: \(service.setTXTRecord(data))")
            service.publish()
            //runloop.run()

            
        } else {
            print("No valid IP address found.")
        }
       
    }
    
    func extractIPAddress(from strings: [String]) -> String? {
        let ipPattern = #"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})"#
        let localhostIP = "127.0.0.1"
        
        let regex = try! NSRegularExpression(pattern: ipPattern, options: [])
        
        for string in strings {
            let range = NSRange(string.startIndex..<string.endIndex, in: string)
            let matches = regex.matches(in: string, options: [], range: range)
            
            for match in matches {
                if let matchRange = Range(match.range(at: 1), in: string) {
                    let ipAddress = String(string[matchRange])
                    
                    if ipAddress != localhostIP {
                        return ipAddress
                    }
                }
            }
        }
        
        return nil
    }
}


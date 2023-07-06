//
//  Server.swift
//  TapAppMac
//
//  Created by Shady Mansour on 06.07.23.
//

import Foundation
import Network

@available(macOS 10.14, *)
class Server {
    let port: NWEndpoint.Port
    let listener: NWListener
    private var isConnected: Bool
    
    private var connectionsByID: [Int: ServerConnection] = [:]

    init(port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        listener = try! NWListener(using: .tcp, on: self.port)
        isConnected = false
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
    }
    
    private func registerService() {
        let service = NetService(domain: "",
                                 type: "_tapapp._tcp.",
                                 name: Host.current().name!,
                                 port: Int32(self.port.rawValue))
        print(Host.current().name!)
        print(Int32(self.port.rawValue))
        service.publish()
    }
}




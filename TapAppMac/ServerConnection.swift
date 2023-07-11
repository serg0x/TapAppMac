//
//  ServerConnection.swift
//  TapAppMac
//
//  Created by Shady Mansour on 06.07.23.
//

import Foundation
import Network
import CoreGraphics

@available(macOS 10.14, *)
class ServerConnection {
    //The TCP maximum package size is 64K 65536
    let MTU = 65536

    private static var nextID: Int = 0
    let  connection: NWConnection
    let id: Int

    init(nwConnection: NWConnection) {
        connection = nwConnection
        id = ServerConnection.nextID
        ServerConnection.nextID += 1
    }

    var didStopCallback: ((Error?) -> Void)? = nil

    func start() {
        print("connection \(id) will start")
        connection.stateUpdateHandler = self.stateDidChange(to:)
        setupReceive()
        connection.start(queue: .main)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            connectionDidFail(error: error)
        case .ready:
            print("connection \(id) ready")
        case .failed(let error):
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: MTU) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8)
                print("connection \(self.id) did receive, data: \(data as NSData) string: \(message ?? "-")")
                if(message == "1"){
                    self.triggerKeyPress(keyCode: 36) ///Simulate enter
                    if let res = "Done Enter".data(using: .utf8) {
                        self.send(data: res)
                    }
                    
                }else if(message == "2")
                {
                    self.triggerKeyPress(keyCode:48) //Simulate Tab
                    if let res = "Done Tab".data(using: .utf8) {
                        self.send(data: res)
                    }
                }else{
                    if let res = "Command unknown".data(using: .utf8) {
                        self.send(data: res)
                    }
                }
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }


    func send(data: Data) {
        self.connection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
            print("connection \(self.id) did send, data: \(data as NSData)")
        }))
    }

    func stop() {
        print("connection \(id) will stop")
    }



    private func connectionDidFail(error: Error) {
        print("connection \(id) did fail, error: \(error)")
        stop(error: error)
    }

    private func connectionDidEnd() {
        print("connection \(id) did end")
        stop(error: nil)
    }

    private func stop(error: Error?) {
        connection.stateUpdateHandler = nil
        connection.cancel()
        if let didStopCallback = didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
    
    func triggerKeyPress(keyCode: UInt16) {
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)
        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)
        

        if let keyDownEvent = keyDownEvent, let keyUpEvent = keyUpEvent {
            keyDownEvent.post(tap: .cghidEventTap)
            keyUpEvent.post(tap: .cghidEventTap)
        }
    }
    
}



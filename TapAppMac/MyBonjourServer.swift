//
//  ServerDelegate.swift
//  TapAppMac
//
//  Created by Sergej Lotz on 05.07.23.
//

import Foundation
import SwiftUI

class MyBonjourServer: NSObject, NetServiceDelegate, StreamDelegate {
    private var server: NetService?

    override init() {
        super.init()

        // Initialize the server
        server = NetService(domain: "", type: "_wonderful-pml._tcp", name: "Wonderful PML", port: 1337)
        
        // Wire up the delegate and publish
        server?.delegate = self
        print ("1")
        server?.publish()
        print ("2")
    }
    
    // MARK: - NetServiceDelegate
    

    func netServiceDidPublish(_ sender: NetService) {
        print("Bonjour service published successfully \(sender)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish Bonjour service: \(errorDict)")
    }
    // Handle new connections
    func handleIncomingConnection(inputStream: InputStream, outputStream: OutputStream) {
        // Do your handling here
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            if let input = aStream as? InputStream {
                var buffer = [UInt8](repeating: 0, count: 4096)
                while (input.hasBytesAvailable) {
                    let len = input.read(&buffer, maxLength: buffer.count)
                    if(len > 0){
                        // Parse inputs
                    }
                    else {
                        print("No data from input stream")
                    }
                }
            }
        case Stream.Event.errorOccurred:
            print("Stream event error occurred: \(aStream.streamError?.localizedDescription ?? "")")
        case Stream.Event.endEncountered:
            print("Stream event end encountered.")
        default:
            print("Stream event default")
        }
    }
}

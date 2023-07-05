import Foundation
import Network

class NetworkManager {
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port
    let connection: NWConnection
  
    init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
        self.connection = NWConnection(host: self.host, port: self.port, using: .tcp)
        connectAndSend()
    }

    func connectAndSend() {
        // Start the connection
        
        connection.start(queue: DispatchQueue.global())
        print(connection.parameters)
        print(connection.parameters)
        // Send data to IPhone
        let dataToSend = "Your Message".data(using: .utf8)
        connection.send(content: dataToSend, completion: .contentProcessed { error in
            if let error = error {
                // Handle error in sending
                print("Data did not send, error: \(error)")
            } else {
                // Data has been successfully sent!
                print("Data has been sent!")
            }
        })

        // Receive data from iPhone
        connection.receiveMessage { (data, context, isComplete, error) in
            if let data = data, !data.isEmpty {
                // Convert data to a string and print
                let str = String(data: data, encoding: .utf8)
                print("Received data: \(str ?? "none")")
            }
        }
    }
}

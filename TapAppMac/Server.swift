import Foundation
import Network

class ConnectionWrapper: Hashable {
    let connection: NWConnection
    
    init(connection: NWConnection) {
        self.connection = connection
    }
    
    static func == (lhs: ConnectionWrapper, rhs: ConnectionWrapper) -> Bool {
        return lhs.connection.endpoint == rhs.connection.endpoint
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(connection.endpoint)
    }
}

class Server {
    var listener: NWListener?
    var connections = Set<ConnectionWrapper>()

    func startServer() {
        do {
            listener = try NWListener(using: .tcp, on: 0)
            listener?.service = NWListener.Service(name: "MyServer", type: "_myapp._tcp")
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
                let wrapper = ConnectionWrapper(connection: newConnection)
                self.connections.insert(wrapper)
                // Handle incoming data and manage connections
                // Implement your logic here based on your app requirements
            }
            listener?.start(queue: .main)
        } catch {
            print("Failed to start server: \(error.localizedDescription)")
        }
    }
}

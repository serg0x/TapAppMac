//
//  ContentView.swift
//  TapAppMac
//
//  Created by Sergej Lotz on 02.07.23.
//

import SwiftUI

let url = URL(string: "10.163.181.83")!
let communicator = TCP_Communicator(url: url, port: 12234)


struct ContentView: View {
    @State private var id: String = url.path
    @State private var connectionStatus: String = "Not connected"
   
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
//            Text("ID: \(id)")
//                .padding()
//            
//            Text("Status: \(connectionStatus)")
//                .padding()
//
//            Button("Connect", action: {
//                communicator.connect()
//            })
//            Button("Send", action: {
//                communicator.send(message: "He")
//            })
//            Button("Stream", action: {
//                //communicator.stream(<#T##aStream: Stream##Stream#>, handle: <#T##Stream.Event#>)
//            })
//            
//            .padding()
        }
    }
    

}

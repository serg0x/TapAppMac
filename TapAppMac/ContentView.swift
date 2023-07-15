//
//  ContentView.swift
//  TapAppMac
//
//  Created by Sergej Lotz on 02.07.23.
//

import SwiftUI

var appSettings = AppSettings()


struct ContentView: View {
    

   
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("IP Address: \(appSettings.publishedIpAddress)")
            Text("Port: \(appSettings.publishedPort)")
            Text("Name: \(appSettings.publishedName)")
            Text("Status: \(appSettings.publishedStatus)")
            
//            Text("ID: \(id)")
//                .padding()
//            
//            Text("Status: \(connectionStatus)")
//                .padding()
//
            Button("Restart Server", action: {
                try!server?.stop()
                //try!server?.init(port: 12345 (UInt16))
            })
//            
//            .padding()
        }
    }
    

}



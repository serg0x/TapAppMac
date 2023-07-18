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
            Image("Icon")
            Text("Tap App").font(.headline).fontWeight(.medium).padding(4.0)
            Text("Use your phone to connect").padding(4.0)
            
            HStack{
                VStack(alignment: .leading){
                    Text("IP Address: ")
                    Text("Port: ")
                    Text("Name: ")
                    Text("Status: ")
                }
                VStack(alignment: .leading){
                    Text("\(appSettings.publishedIpAddress)")
                    Text("\(appSettings.publishedPort)")
                    Text("\(appSettings.publishedName)")
                    Text("\(appSettings.publishedStatus)")
                }
            }
            
            

            Button("Stop Server", action: {
                server?.stop()
            }).padding(4.0)
        }
    }
    

}



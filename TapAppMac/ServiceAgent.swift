//
//  ServiceAgent.swift
//  TapAppMac
//
//  Created by Shady Mansour on 06.07.23.
//
import Foundation

class ServiceAgent : NSObject, NetServiceDelegate {
    func netServiceDidPublish(_ sender: NetService) {
        print("Bonjour Service published!")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish Bonjour Service. error: \(errorDict)")
    }
}



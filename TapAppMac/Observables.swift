//
//  Observables.swift
//  TapAppMac
//
//  Created by Raphael Wennmacher on 13.07.23.
//

import Foundation


class AppSettings: ObservableObject {
    @Published var publishedIpAddress: String = ""
    @Published var publishedPort: String = ""
    @Published var publishedName: String = ""
    @Published var publishedStatus: String = ""
}

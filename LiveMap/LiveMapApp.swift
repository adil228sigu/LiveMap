//
//  LiveMapApp.swift
//  LiveMap
//
//  Created by Adilzhan Otarbek on 29.11.2025.
//

import SwiftUI
import GoogleMaps

@main
struct LiveMapApp: App {
    
    init() {
        GMSServices.provideAPIKey("AIzaSyBUEwnuG9ColGU_DROCCwDtzQun10L4R3Y")
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

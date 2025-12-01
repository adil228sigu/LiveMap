//
//  ContentView.swift
//  LiveMap
//
//  Created by Adilzhan Otarbek on 29.11.2025.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    var body: some View {
        GoogleMapView()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

//
//  RepeatersApp.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import SwiftUI

@main
struct RepeatersApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject private var locationData = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environmentObject(locationData)
        }
    }
}

//
//  ContentView.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        RepeaterList()
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}

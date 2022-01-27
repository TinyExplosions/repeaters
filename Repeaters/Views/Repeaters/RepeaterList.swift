//
//  RepeaterList.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import SwiftUI
import CoreLocation

struct RepeaterList: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @EnvironmentObject var locationData: LocationManager
    @State private var showFavoritesOnly = false
    //    @State private var showLocalOnly = false
    
    var filteredRepeaters: [Repeater] {
        modelData.repeaters.filter { repeater in
            (!showFavoritesOnly || repeater.isfavourite)
        }
    }
    
    
    
    //    var localRepeaters: [Repeater] {
    //        repeaters.filter { repeater in
    //            (!showLocalOnly || repeater.nearest_city.contains("Milton Keynes"))
    //        }
    //    }
    @State private var searchText = ""
    @State var newPlaces = [Repeater]()
    
    var body: some View {
        //        let newPlaces =  modelData.repeaters.sorted(by: LocationManager.app.lastLocation ?? CLLocation(latitude: 51.507222, longitude: -0.1275))
        NavigationView {
            List {
                //                Toggle(isOn: $showFavoritesOnly) {
                //                    Text("Favourites only")
                //                }
                ForEach(searchResults) { repeater in
                    NavigationLink {
                        RepeaterDetail(repeater: repeater)
                    } label: {
                        RepeaterRow(repeater: repeater)
                    }
                }
                
            }
            .searchable(text: $searchText)
            //            {
            //                if !searchText.isEmpty {
            //                    ForEach(searchResults, id: \.self) { result in
            //                        Text(result.nearest_city).searchCompletion(result.nearest_city)
            //                    }
            //                }
            //            }
            .listStyle(.inset)
            .navigationTitle("Repeaters")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        }
        .environmentObject(locationData)
        .environmentObject(modelData)
    }
    
    var searchResults: [Repeater] {
        if searchText.isEmpty {
            return modelData.repeaters.sorted(by: locationData.lastLocation)
        } else {
            return modelData.repeaters.filter {
                $0.nearest_city.localizedCaseInsensitiveContains(searchText)
                ||
                $0.callsign.localizedCaseInsensitiveContains(searchText)
                
                
            }
        }
    }
}

struct RepeaterList_Previews: PreviewProvider {
    static var previews: some View {
        RepeaterList()
            .environmentObject(ModelData())
            .environmentObject(LocationManager())
    }
}



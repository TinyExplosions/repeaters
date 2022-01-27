//
//  RepeaterDetail.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import SwiftUI
import CoreLocation

struct RepeaterDetail: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locationData: LocationManager
    
    var repeater: Repeater
    
    var repeaterIndex: Int {
        modelData.repeaters.firstIndex(where: { $0.id == repeater.id })!
    }
    
    var body: some View {
        
        ScrollView {
            MapView(repeater: repeater)
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            //            BigMap(coordinate: repeater.locationCoordinate)
            //                .ignoresSafeArea(edges: .top)
            //                .frame(height: 300)
            
            //            CircleImage(image: repeater.image)
            //                .offset(y: -130)
            //                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack{
                    Text(repeater.callsign)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.repeaters[repeaterIndex].isfavourite)
                }
                HStack {
                    Text(repeater.nearest_city)
                    Spacer()
                    Text(repeater.region)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                HStack {
                    Text("Downlink")
                    Spacer()
                    Text("\(repeater.frequency)")
                }
                HStack {
                    Text("Uplink")
                    Spacer()
                    Text("\(repeater.input_freq)")
                }
                HStack {
                    Text("Offset")
                    Spacer()
                    Text("\(repeater.offset) MHz")
                }
                if(repeater.pl != "") {
                    HStack {
                        Text("Uplink Tone")
                        Spacer()
                        Text("\(repeater.pl)")
                    }
                }
                HStack {
                    Text("Use")
                    Spacer()
                    Text("\(repeater.use)")
                }
                HStack {
                    Text("Bearing")
                    Spacer()
                    Text("\(repeater.getDirection(from: locationData.lastLocation))")
                }
                HStack {
                    Text("Grid Square")
                    Spacer()
                    Text("\(repeater.getGridSquare())")
                }
            }
            .padding()
            
        }
        .navigationTitle("\(repeater.callsign) / \(repeater.nearest_city)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RepeaterDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        RepeaterDetail(repeater: ModelData().repeaters[0])
            .environmentObject(modelData)
    }
}

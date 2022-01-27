//
//  RepeaterRow.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import SwiftUI
import CoreLocation

struct RepeaterRow: View {
    @EnvironmentObject var locationData: LocationManager
    
    var repeater: Repeater
    
    var body: some View {

        HStack {
            if repeater.operational_status.contains("Off-air") {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red)
                    .font(.title.weight(.black))
            } else {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.blue)
                    .font(.title.weight(.black))
            }
            VStack(alignment: .leading){
                HStack{
                    Group {
                    Text("\(repeater.callsign) / \(repeater.nearest_city)")
                    Spacer()
                    let distance = repeater.kmDistance(to: locationData.lastLocation)
                    Text("\(distance)")
                    }
                    .font(.headline)
                }
                HStack(){
                    Group {
                    Text("\(repeater.frequency)")
                    Text("\(repeater.offset)MHz")
                    }
                }
            }
            Spacer()
            if repeater.isfavourite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }

        }
    }
}

struct RepeaterRow_Previews: PreviewProvider {
    static var repeaters = ModelData().repeaters
    
    static var previews: some View {
        Group {
            RepeaterRow(repeater: repeaters[35])
            RepeaterRow(repeater: repeaters[267])
        }
        .previewLayout(.fixed(width: 400, height: 70))
        .environmentObject(ModelData())
        .environmentObject(LocationManager())
    }
}

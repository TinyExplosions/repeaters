//
//  MapView.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    var repeater: Repeater
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var locationData: LocationManager
    @State private var region = MKCoordinateRegion()
    
    @State var annotations: [Repeater] = []
    
    var body: some View {
        
        Map(coordinateRegion: $region,
            showsUserLocation: true,
            annotationItems: annotations) {_ in
            MapAnnotation(coordinate: repeater.locationCoordinate) {
                VStack {
                    Star(corners: 3, smoothness: 0.45)
                        .fill(Color.white)
                        .frame(width: 28, height: 20)
                        .background(Color.black)
                        .clipShape(Star(corners: 3, smoothness: 0.45))
                        .rotationEffect(Angle(degrees: 180))
                        .offset(y: 49)
                    Image(systemName: "antenna.radiowaves.left.and.right.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.green)
                        .clipShape(Circle())
                }
            }
        }
            .onAppear{
                region = MKCoordinateRegion(center: repeater.locationCoordinate.middleLocationWith(location: CLLocationCoordinate2D(latitude: locationData.lastLocation.coordinate.latitude,
                    longitude: locationData.lastLocation.coordinate.longitude) ),
                                            latitudinalMeters: (repeater.distance(to: locationData.lastLocation) * 1.2),
                                            longitudinalMeters: (repeater.distance(to: locationData.lastLocation) * 1.2))
                annotations = [repeater]
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(repeater: ModelData().repeaters[110])
            .environmentObject(ModelData())
    }
}

extension CLLocationCoordinate2D {
    // MARK: CLLocationCoordinate2D+MidPoint
    func middleLocationWith(location:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1 = longitude * .pi / 180
        let lon2 = location.longitude * .pi / 180
        let lat1 = latitude * .pi / 180
        let lat2 = location.latitude * .pi / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / .pi, lon3 * 180 / .pi)
        return center
    }
}

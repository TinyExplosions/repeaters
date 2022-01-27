//
//  BigMap.swift
//  Repeaters
//
//  Created by Al Graham on 22/01/2022.
//

import SwiftUI
import MapKit

extension Repeater {
    func getMarker(currentLocation: CLLocationCoordinate2D) -> MapMarker {
            return MapMarker(coordinate: locationCoordinate, tint: getPinColor(currentLocation: currentLocation))
    }
}

struct BigMap: View {
    var coordinate: CLLocationCoordinate2D
    @EnvironmentObject var modelData: ModelData
    @State private var region: MKCoordinateRegion = .init(center: .init(latitude: 52.04172, longitude: -0.75583), latitudinalMeters: 3000, longitudinalMeters: 3000)
    
    
    var body: some View {
        Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: modelData.repeaters
                ) { repeater in
//                repeater.getMarker(currentLocation: coordinate)
//            MapMarker(coordinate: repeater.locationCoordinate, tint: repeater.getPinColor(currentLocation: coordinate))
//            if repeater.isCurrent(currentLocation: coordinate) {
               
//            }
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
//                            .symbolRenderingMode(.hierarchical)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(repeater.getPinColor(currentLocation: coordinate))
                            .clipShape(Circle())
//                        addOverlay(MKGeodesicPolyline(
//                            coordinates: [coordinate, repeater.locationCoordinate],
//                            count: 2
//                          ))
                    }
                }
                }
////                ZStack{
////                    RoundedRectangle(cornerRadius: 10)
////                        .fill(Color(UIColor.systemBackground))
////                        .shadow(radius: 2, x: 2, y: 2)
////                    VStack{
////                        NavigationLink(destination: RepeaterDetail(repeater: repeater)) {
////                            Image(systemName: "antenna.radiowaves.left.and.right")
////                                .symbolRenderingMode(.hierarchical)
////                                .foregroundColor(.blue)
////                                .font(.title.weight(.black))
//////                            Text(repeater.callsign)
//////                                .fontWeight(.bold)
////                        }
////                    }
////                }
////            }
////            MapMarker(coordinate: $0.locationCoordinate)
//        }
        .onAppear{
//            let newDistance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: LocationManager.app.lastLocation ?? CLLocation(latitude: 51.507222, longitude: -0.1275))
//            let region2 = MKCoordinateRegion(center: coordinate, latitudinalMeters: newDistance, longitudinalMeters: newDistance)
//            region = region2
            setRegion(coordinate)
        }
        .ignoresSafeArea(edges: .all)
    }
       
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 3000,
            longitudinalMeters: 3000
        )
    }
}

struct BigMap_Previews: PreviewProvider {
    static var previews: some View {
        BigMap(coordinate: CLLocationCoordinate2D(latitude: 52.04172, longitude: -0.75583))
            .environmentObject(ModelData())
    }
}

struct Star: Shape {
    // store how many corners the star has, and how smooth/pointed it is
    let corners: Int
    let smoothness: CGFloat

    func path(in rect: CGRect) -> Path {
        // ensure we have at least two corners, otherwise send back an empty path
        guard corners >= 2 else { return Path() }

        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = -CGFloat.pi / 2

        // calculate how much we need to move with each star corner
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)

        // figure out how much we need to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness

        // we're ready to start with our path now
        var path = Path()

        // move to our initial position
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))

        // track the lowest point we draw to, so we can center later
        var bottomEdge: CGFloat = 0

        // loop over all our points/inner points
        for corner in 0..<corners * 2  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: CGFloat

            // if we're a multiple of 2 we are drawing the outer edge of the star
            if corner.isMultiple(of: 2) {
                // store this Y position
                bottom = center.y * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // we're not a multiple of 2, which means we're drawing an inner point

                // store this Y position
                bottom = innerY * sinAngle

                // …and add a line to there
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }

            // if this new bottom point is our lowest, stash it away for later
            if bottom > bottomEdge {
                bottomEdge = bottom
            }

            // move on to the next corner
            currentAngle += angleAdjustment
        }

        // figure out how much unused space we have at the bottom of our drawing rectangle
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2

        // create and apply a transform that moves our path down by that amount, centering the shape vertically
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)
    }
}


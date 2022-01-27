//
//  Repeater.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import Foundation
import SwiftUI
import CoreLocation

struct Repeater: Hashable, Codable, Identifiable {
    var state_id: String
    var frequency: Float
    var input_freq: Float
    var pl: String
    //    var tsq: String
    var nearest_city: String
    var landmark: String
    var region: String
    var country: String
    var precise: Float
    var callsign: String
    var use: String
    var operational_status: String
    //    var allstar_node: Float
    //    var echolink_node: Float
    //    var irlp_node: Float
    var wires_node: String
    var fm_analog: Bool
    var dmr: Bool
    //    var dmr_color_code: Float
    var dmr_id: Float
    var d_star: Bool
    var nxdn: Bool
    var p_25_nac: String
    var tetra: Bool
    var tetra_mcc: String
    var tetra_mnc: String
    var system_fusion: Bool
    var ysf_dg_id_uplink: String
    var ysf_dg_is_downlink: String
    var ysf_dsc: String
    var last_update: String
    var trustee: String
    var offset: String
    var id: Int
    var isfavourite: Bool
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    var location: CLLocation {
        return CLLocation(latitude: self.coordinates.latitude, longitude: self.coordinates.longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
    
    func kmDistance(to location: CLLocation) -> String {
        let distance = distance(to: location)
        return "\(String(format: "%.02f", (distance / 1000) ))km"
    }
    
    private func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    private func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    private func bearingFrom(from : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: from.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: from.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: self.location.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: self.location.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    func getDirection(from : CLLocation) -> String {
        let bearing = bearingFrom(from: from);
        switch bearing {
        case -202.4...(-157.5):
            return "South"
        case -157.4...(-112.5):
            return "South West"
        case -112.4...(-67.5):
            return "West"
        case -67.4...(-22.5):
            return "North West"
        case -22.4...0:
            return "North"
        case 0...22.4:
            return "North"
        case 22.5...67.4:
            return "North East"
        case 67.5...112.4:
            return "East"
        case 112.5...157.4:
            return "South East"
        case 157.5...202.4:
            return "South"
        case 202.5...247.4:
            return "South West"
        case 247.5...292.4:
            return "West"
        case 292.5...337.4:
            return "North West"
        case 337.5...360:
            return "North"
        default:
            return "Bearing Unknown"
        }
    }
    
    public func isCurrent(currentLocation: CLLocationCoordinate2D) -> Bool {
        return locationCoordinate.latitude == currentLocation.latitude
    }
    
    public func getPinColor(currentLocation: CLLocationCoordinate2D) -> Color {
        if isCurrent(currentLocation: currentLocation) {
            return Color.green
        }
        if operational_status.contains("Off-air") {
            return Color.red
        }
        return Color.blue
    }
    
    public func getGridSquare() -> String {
        return Helper.maidenhead(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }

}

extension Array where Element == Repeater {
    
    mutating func sort(by location: CLLocation) {
        return sort(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
    
    func sorted(by location: CLLocation) -> [Repeater] {
        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
}

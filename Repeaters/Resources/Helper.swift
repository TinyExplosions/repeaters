//
//  Helper.swift
//  Repeaters
//
//  Created by Al Graham on 26/01/2022.
//

import Foundation
import MapKit


class Helper{
    static func postRequest() -> [String:String] {
         // do a post request and return post data
         return ["someData" : "someData"]
    }
    
    static private func getIndex(string: String, position: Int) -> String.Index {
        return string.index(string.startIndex, offsetBy: position);
    }
    
    static func maidenhead(latitude: Double, longitude: Double) -> String {
        let upper = "ABCDEFGHIJKLMNOPQRSTUVWX"
        let lower = "abcdefghijklmnopqrstuvwx"
        var lonDegrees: Double = 360
        var latDegrees: Double = 180
        var lon = longitude + 180.0
        var lat = latitude + 90.0
        var lonRemainder = lon
        var latRemainder = lat
        
        func gridPair(divisions: Double) -> (Double, Double) {
            lonDegrees = lonDegrees/divisions
            latDegrees = latDegrees/divisions
            lon = lonRemainder/lonDegrees
            lonRemainder = lonRemainder.truncatingRemainder(dividingBy: lonDegrees)
            lat = latRemainder/latDegrees
            latRemainder = latRemainder.truncatingRemainder(dividingBy: latDegrees)
            return (lon, lat)
        }
        
        let (gridLonField, gridLatField) = gridPair(divisions: 18)
        let (gridLonSquare, gridLatSquare) = gridPair(divisions: 10)
        let (gridLonSubSquare, gridLatSubSquare) = gridPair(divisions: 24)
        //        let (gridLonExtSquare, gridLatExtSquare) = gridPair(divisions: 10)
        //        let (gridLonSubExtSquare, gridLatSubExtSquare) = gridPair(divisions: 24)
        
        //      return
        //        "\(upper[getIndex(string: upper, position: Int(gridLonField))])\(upper[getIndex(string: upper, position: Int(gridLatField))])\(Int(gridLonSquare))\(Int(gridLatSquare))\(lower[getIndex(string: lower, position: Int(gridLonSubSquare))])\(lower[getIndex(string: lower, position: Int(gridLatSubSquare))])\(Int(gridLonExtSquare))\(Int(gridLatExtSquare))\(lower[getIndex(string: lower, position: Int(gridLonSubExtSquare))])\(lower[getIndex(string: lower, position: Int(gridLatSubExtSquare))])"
        return "\(upper[getIndex(string: upper, position: Int(gridLonField))])\(upper[getIndex(string: upper, position: Int(gridLatField))])\(Int(gridLonSquare))\(Int(gridLatSquare))\(lower[getIndex(string: lower, position: Int(gridLonSubSquare))])\(lower[getIndex(string: lower, position: Int(gridLatSubSquare))])"
    }
    
    
}

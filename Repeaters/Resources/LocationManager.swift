//
//  LocationManager.swift
//  Repeaters
//
//  Created by Al Graham on 21/01/2022.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    // setting a default location of London
    @Published var lastLocation = CLLocation(latitude: 51.507222, longitude: -0.1275)
    
    override init() {
        print("initialise locationManager")
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, "Location Updated: \(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

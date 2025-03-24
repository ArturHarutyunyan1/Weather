//
//  LocationManager.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI
import Foundation
import MapKit

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    @Published var latitude: Double? = nil
    @Published var longitude: Double? = nil
    @Published var status: Bool = false
    @Published var error: String = ""
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            self.status = true
        } else {
            self.status = false
            self.error = "Your location services are disabled/declined. Please, allow them in settings in order to use application"
        }
    }
}

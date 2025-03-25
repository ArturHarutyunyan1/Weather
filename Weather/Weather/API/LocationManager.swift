//
//  LocationManager.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI
import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    @Published var latitude: Double? = nil
    @Published var longitude: Double? = nil
    @Published var status: Bool = false
    @Published var isPermissionChecked: Bool = false
    @Published var error: String = ""

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkPermission() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        switch authorizationStatus {
        case .notDetermined:
            locationPermission()
        case .authorizedWhenInUse, .authorizedAlways:
            isPermissionChecked = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            isPermissionChecked = true
            self.status = false
            self.error = "Your location services are disabled. Please enable them in settings."
        @unknown default:
            isPermissionChecked = true
        }
    }

    func locationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.status = true
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkPermission()  // Automatically re-check on changes
    }
}

//
//  ContentView.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var apiManager: ApiManager
    @StateObject private var locationManager = LocationManager()
    @State private var cities: [WeatherDetails] = []
    var body: some View {
        GeometryReader {geometry in
            VStack {
                if locationManager.status {
                    if let details = apiManager.weatherDetails {
                        WeatherDetailsView(weather: details)
                    }
                } else {
                    SearchView(cities: $cities)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.locationPermission()
            }
        }
        .onChange(of: locationManager.status) {
            if let lat = locationManager.latitude, let lon = locationManager.longitude, locationManager.status {
                Task {
                    await apiManager.reverseGeocoding(lat: lat, lon: lon)
                    await apiManager.getWeatherDetails(latitude: lat, longitude: lon)
                    if let city = apiManager.reversedResult?.address.city,
                       let country = apiManager.reversedResult?.address.country,
                       let id = apiManager.reversedResult?.place_id{
                        if !cities.contains(where: {$0.id == id && $0.city == city && $0.country == country}) {
                            let newCity = WeatherDetails(id: id, city: city, country: country, admin4: nil)
                            cities.append(newCity)
                            let encoder = JSONEncoder()
                            if let encodedData = try? encoder.encode(cities) {
                                UserDefaults.standard.set(encodedData, forKey: "cities")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let apiManager = ApiManager()
    ContentView()
        .environmentObject(apiManager)
        .preferredColorScheme(.dark)
}

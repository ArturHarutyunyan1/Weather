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
    @State private var cities: [Weather] = []
    @State private var searchedCity: Weather? = nil
    @State private var show: Bool = false
    var body: some View {
        GeometryReader {geometry in
            VStack {
                SearchView(cities: $cities, searchedCity: $searchedCity)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .sheet(isPresented: $show) {
                if let details = apiManager.weatherDetails {
                    WeatherDetailsView(weather: details)
                }
            }
        }
        .onAppear {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.locationPermission()
            }
        }
        .onChange(of: locationManager.status) {
            if let lat = locationManager.latitude,
               let lon = locationManager.longitude {
                Task {
                    await apiManager.reverseGeocoding(lat: lat, lon: lon)
                    if let reversedResults = apiManager.reversedResult {
                        await apiManager.getWeatherDetails(latitude: lat, longitude: lon)
                        if var details = apiManager.weatherDetails {
                            // Update the details with the location info
                            details.locationInfo = Weather.LocationInfo(id: reversedResults.place_id, city: reversedResults.address.city, country: reversedResults.address.country)
                            
                            // Assign the updated details to searchedCity
                            searchedCity = details
                            
                            // Append to cities array if not already there
                            if !cities.contains(where: { $0.locationInfo?.id == reversedResults.place_id }) {
                                cities.append(details)
                            }
                            
                            // Save the cities
                            saveCities()
                            
                            // Show the weather details view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                show = true
                            }
                        }
                    }
                }
            }
        }
    }
    private func saveCities() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(cities) {
            UserDefaults.standard.set(encodedData, forKey: "cities")
        }
    }
}

#Preview {
    let apiManager = ApiManager()
    ContentView()
        .environmentObject(apiManager)
        .preferredColorScheme(.dark)
}

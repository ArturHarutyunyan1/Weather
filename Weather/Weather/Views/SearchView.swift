//
//  SearchView.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    @EnvironmentObject private var apiManager: ApiManager
    @StateObject private var locationManager = LocationManager()
    @State private var cities: [WeatherDetails] = []
    @State private var selectedItem: WeatherDetails? = nil
    @Namespace private var animation: Namespace.ID
    @State private var show: Bool = false
    private let key = "cities"
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if isFocused && searchText.count > 3 {
                        if !apiManager.searchResults.isEmpty {
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(apiManager.searchResults, id: \.id) { result in
                                    HStack {
                                        Button(action: {
                                            Task {
                                                print("\(result.latitude) \(result.longitude)")
                                                await apiManager.getWeatherDetails(latitude: result.latitude, longitude: result.longitude)
                                                if !cities.contains(where: {$0.id == result.id && $0.city == result.name && $0.country == result.country}) {
                                                    let newCity = WeatherDetails(id: result.id, city: result.name, country: result.country)
                                                    cities.append(newCity)
                                                    saveCities()
                                                }
                                                isFocused = false
                                                show = true
                                            }
                                        }, label: {
                                            Text("\(result.name), \(result.country)")
                                        })
                                        .foregroundStyle(.white)
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                }
                                Spacer()
                            }
                        } else {
                            Text("Nothing found")
                        }
                    }
                    if !isFocused {
                        ZStack {
                            ScrollView {
                                ForEach(cities, id: \.id) { city in
                                    CardView(weather: $selectedItem, item: city, animation: animation)
                                }
                            }
                            .zIndex(0)
                        }
                    }
                }
                .sheet(isPresented: $show) {
                    VStack {
                        if let details = apiManager.weatherDetails {
                            Text("\(details.current.temperature_2m)")
                        } else {
                            Text("NIGGA")
                        }
                    }
                }
                .searchable(text: $searchText, prompt: Text("Search"))
                .navigationTitle("Weather")
                .searchFocused($isFocused)
            }
            .onAppear {
                withAnimation {
                    loadCities()
                }
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.locationPermission()
                }
            }
            .onChange(of: locationManager.status) {
                if let lat = locationManager.latitude, let lon = locationManager.longitude {
                    Task {
                        await apiManager.reverseGeocoding(lat: lat, lon: lon)
                            if let city = apiManager.reversedResult?.address.city,
                               let country = apiManager.reversedResult?.address.country,
                               let id = apiManager.reversedResult?.place_id{
                                if !cities.contains(where: {$0.id == id && $0.city == city && $0.country == country}) {
                                    let newCity = WeatherDetails(id: id, city: city, country: country, admin4: nil)
                                    cities.append(newCity)
                                    saveCities()
                                }
                        }
                    }
                }
            }
            .onChange(of: searchText) { newValue, _ in
                Task {
                    if newValue.count > 3 {
                        await apiManager.searchQuery(query: newValue)
                    }
                }
            }
            VStack {
                if let selectedItem = selectedItem {
                    ExpandedCard(weather: $selectedItem, item: selectedItem, animation: animation)
                        .zIndex(1)
                }
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.90, blendDuration: 0.2), value: selectedItem)
    }
    private func loadCities() {
        if let savedCities = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([WeatherDetails].self, from: savedCities) {
                cities = decodedData
            }
        }
    }
    private func saveCities() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(cities) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
}

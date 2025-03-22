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
    @Binding var cities: [WeatherDetails]
    @State private var selectedItem: WeatherDetails? = nil
    @Namespace private var animation: Namespace.ID
    @State private var show: Bool = false
    private let key = "cities"
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if isFocused {
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
                            ScrollView (.vertical, showsIndicators: false) {
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
                            WeatherDetailsView(weather: details)
                        } else {
                            if let error = apiManager.errorMessage {
                                Text("Error - \(error)")
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: Text("Search"))
                .navigationTitle("Weather")
                .searchFocused($isFocused)
            }
            .onAppear() {
                Task {
                    loadCities()
                }
            }
            .onChange(of: searchText) { newValue, _ in
                Task {
                    if newValue.count > 3 {
                        await apiManager.searchQuery(query: newValue)
                    }
                }
            }
        }
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

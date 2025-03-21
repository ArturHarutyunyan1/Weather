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
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if isFocused && searchText.count > 3 {
                        if !apiManager.searchResults.isEmpty {
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(apiManager.searchResults, id: \.id) { result in
                                    HStack {
                                        Button(action: {
                                            
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
                .searchable(text: $searchText, prompt: Text("Search"))
                .navigationTitle("Weather")
                .searchFocused($isFocused)
            }
            .onAppear {
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.locationPermission()
                }
            }
            .onChange(of: locationManager.latitude) {
                if let lat = locationManager.latitude, let lon = locationManager.longitude {
                    Task {
                        await apiManager.reverseGeocoding(lat: lat, lon: lon)
                        DispatchQueue.main.async {
                            if let city = apiManager.reversedResult?.address.city,
                               let country = apiManager.reversedResult?.address.country {
                                let newCity = WeatherDetails(id: 0, city: city, country: country, admin4: nil, color: .blue)
                                cities.append(newCity)
                            }
                        }
                    }
                }
            }
            .onChange(of: searchText) { newValue, _ in
                Task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        apiManager.fetchQuery(query: newValue)
                    }
                }
            }
            if let selectedItem = selectedItem {
                ExpandedCard(weather: $selectedItem, item: selectedItem, animation: animation)
                    .zIndex(1)
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.90, blendDuration: 0.2), value: selectedItem)
    }
}

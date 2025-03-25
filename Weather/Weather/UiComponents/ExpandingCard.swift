//
//  ExpandingCard.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct CityList: View {
    @Binding var cities: [Weather]
    var body: some View {
        VStack {
            List {
                ForEach(cities, id: \.locationInfo?.id) {city in
                    if let icon = city.status?.statusIcon,
                       let temp = city.current?.temperature_2m,
                       let status = city.status?.statusText,
                       let cityName = city.locationInfo?.city,
                       let country = city.locationInfo?.country {
                        NavigationLink {
                            WeatherDetailsView(weather: city)
                        } label :{
                            HStack {
                                VStack {
                                    HStack {
                                        Image(systemName: icon)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(status)")
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(country), \(cityName)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Spacer()
                                    }
                                }
                                HStack {
                                    Text("\(temp, specifier: "%.1f")°")
                                        .font(.system(size: 25))
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteCity)
            }
        }
    }
    private func deleteCity(at offsets: IndexSet) {
        cities.remove(atOffsets: offsets)
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(cities) {
            UserDefaults.standard.set(encodedData, forKey: "cities")
        }
    }
}


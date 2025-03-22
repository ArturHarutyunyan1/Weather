//
//  ExpandingCard.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct CardView: View {
    @Binding var weather: WeatherDetails?
    var item: WeatherDetails
    let animation: Namespace.ID
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue)
            }
            .matchedGeometryEffect(id: item.id, in: animation)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 150)
            HStack {
                VStack {
                    Text("\(item.city)")
                    Text("\(item.country)")
                }
                .font(.system(size: 42))
            }
        }
        .onTapGesture {
            weather = item
        }
    }
}

struct ExpandedCard: View {
    @Binding var weather: WeatherDetails?
    var item: WeatherDetails
    let animation: Namespace.ID
    @EnvironmentObject private var apiManager: ApiManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background color for the expanded view
                RoundedRectangle(cornerRadius: 20)
                    .fill(.blue)
                    .matchedGeometryEffect(id: item.id, in: animation)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                VStack {
                    if let details = apiManager.weatherDetails {
                        Text("Weather Details for \(item.city), \(item.country)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()

                        // Display weather details
//                        Text("Temperature: \(details.main.temp)°C")
//                            .foregroundColor(.white)
//                            .padding()
//                        Text("Weather: \(details.weather.first?.description ?? "Unknown")")
//                            .foregroundColor(.white)
//                            .padding()
//                        Text("Humidity: \(details.main.humidity)%")
//                            .foregroundColor(.white)
//                            .padding()
                    } else {
                        if let error = apiManager.errorMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .transition(.opacity)
            .edgesIgnoringSafeArea(.all)
        }
        .onTapGesture {
            weather = nil // Close expanded view on tap
        }
        .zIndex(999)
    }
}

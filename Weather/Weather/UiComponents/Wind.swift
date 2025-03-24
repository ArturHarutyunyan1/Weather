//
//  Wind.swift
//  Weather
//
//  Created by Artur Harutyunyan on 24.03.25.
//

import SwiftUI

struct Wind: View {
    let windSpeed: Double
    let windDirection: Double
    let gusts: Double
    let weatherStyle: WeatherStyle
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text("Wind")
                        Spacer()
                        Text("\(windSpeed, specifier: "%.0f") km/h")
                    }
                    HStack {
                        Text("Gusts")
                        Spacer()
                        Text("\(gusts, specifier: "%.0f") km/h")
                    }
                    HStack {
                        Text("Direction")
                        Spacer()
                        Text("\(windDirection, specifier: "%.0f")° \(angleToDirection(angle: windDirection))")
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.45)
                VStack {
                    Compass(weatherStyle: weatherStyle, direction: windDirection)
                }
                .frame(width: UIScreen.main.bounds.width * 0.45)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
    func angleToDirection(angle: Double) -> String {
        switch (angle) {
        case 0..<22.5, 337.5..<360:
            return "N"
        case 22.5..<67.5:
            return "NE"
        case 67.5..<112.5:
            return "E"
        case 112.5..<157.5:
            return "SE"
        case 157.5..<202.5:
            return "S"
        case 202.5..<247.5:
            return "SW"
        case 247.5..<292.5:
            return "W"
        case 292.5..<337.5:
            return "NW"
        default:
            return "Unknown"
        }
    }
}

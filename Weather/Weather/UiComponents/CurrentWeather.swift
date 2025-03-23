//
//  CurrentWeather.swift
//  Weather
//
//  Created by Artur Harutyunyan on 23.03.25.
//

import SwiftUI

struct CurrentWeather: View {
    var icon: String = ""
    var temperature: Double = 0
    var status: String = ""
    var apparent: Double = 0
    var city: String = ""
    var country: String = ""
    var wind: Double = 0
    var weatherStyle: WeatherStyle
    var date: String = ""
    var body: some View {
        VStack {
            VStack {
                Text("Currently")
                    .font(.custom("Poppins-Medium", size: 23))
            }
            .padding()
            
            VStack {
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 73.61, height: 55.79)
                    Text("\(temperature, specifier: "%.1f")°")
                        .font(.custom("Poppins-Medium", size: 73))
                }
                VStack {
                    Text("\(status)")
                        .font(.custom("Poppins-Medium", size: 20))
                }
                VStack {
                    Text("\(city), \(country)")
                }
                VStack {
                    Text("\(date)")
                }
                VStack {
                    HStack {
                        Text("Feels like \(apparent, specifier: "%.1f")°")
                        Text("|")
                        HStack {
                            Image(systemName: "wind")
                            Text("\(wind, specifier: "%.1f")km/h")
                        }
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(weatherStyle.backgroundColor)
        .foregroundStyle(weatherStyle.foregroundColor)
        .cornerRadius(20)
    }
}

//
//  DailyWeather.swift
//  Weather
//
//  Created by Artur Harutyunyan on 23.03.25.
//

import SwiftUI

struct DailyForecast: View {
    let daily: Weather.Daily
    let statusList: Weather.StatusArray?
    let weatherStyle: WeatherStyle
    var body: some View {
        VStack {
            ForEach(daily.time.indices, id:\.self) {index in
                HStack {
                    Text("Mon")
                    if let icon = statusList?.statusIcon?[index] {
                        Image(systemName: icon)
                    }
                    let min = daily.temperature_2m_min[index]
                    let max = daily.temperature_2m_max[index]
                    Text("\(min, specifier: "%.1f")°")
                    VStack {
                        ProgressView("", value: min, total: max)
                            .tint(weatherStyle.backgroundColor)
                        Spacer()
                        Spacer()
                    }
                    Text("\(max, specifier: "%.1f")°")
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

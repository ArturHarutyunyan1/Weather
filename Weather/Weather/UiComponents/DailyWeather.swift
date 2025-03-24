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
                    Text("\(getWeekDay(day: index))")
                    if let icon = statusList?.statusIcon?[index] {
                        Image(systemName: icon)
                    }
                    let min = daily.temperature_2m_min[index]
                    let max = daily.temperature_2m_max[index]
                    Text("\(min, specifier: "%.1f")°")
                    VStack {
                        let minValue = daily.temperature_2m_min.min() ?? 0
                        let normalizedMin = daily.temperature_2m_min[index] - minValue
                        let normalizedMax = daily.temperature_2m_max[index] - minValue
                        let progressValue = normalizedMin / (normalizedMax == 0 ? 1 : normalizedMax)
                        ProgressView(value: progressValue)
                                .tint(weatherStyle.backgroundColor)
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
    private func getWeekDay(day: Int) -> String {
        switch day {
        case 0:
            return "Mon"
        case 1:
            return "Tue"
        case 2:
            return "Wed"
        case 3:
            return "Thu"
        case 4:
            return "Fri"
        case 5:
            return "Sat"
        case 6:
            return "Sun"
        default:
            return "Unknown"
        }
    }
}

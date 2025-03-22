//
//  Weather.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct WeatherStyle {
    let imageName: String
    let foregroundColor: Color
    let backgroundColor: Color
}

enum WeatherBackground: String {
    case sunrise, afternoon, evening, night
    case sunnyMorning, sunnyDay, sunnyEvening
    case cloudyMorning, cloudyDay, cloudyEvening, cloudyNight
    case rainyMorning, rainyDay, rainyNight
    case snowyDay, snowyNight
    
    var style: WeatherStyle {
        switch (self) {
        case .sunnyMorning:
            return WeatherStyle(
                imageName: "sunny-morning",
                foregroundColor: .sunnyMorningBackground,
                backgroundColor: .sunnyMorningForeground
            )
        case .sunnyDay:
            return WeatherStyle(
                imageName: "sunny-day",
                foregroundColor: .sunnyDayBackground,
                backgroundColor: .sunnyDayForeground
            )
        case .sunnyEvening:
            return WeatherStyle(
                imageName: "sunny-evening",
                foregroundColor: .sunnyEveningBackground,
                backgroundColor: .sunnyEveningForeground
            )
        
        case .cloudyMorning:
            return WeatherStyle(
                imageName: "cloudy-morning",
                foregroundColor: .cloudyMorningBackground,
                backgroundColor: .cloudyMorningForeground
            )
        case .cloudyDay:
            return WeatherStyle(
                imageName: "cloudy-day",
                foregroundColor: .cloudyDayBackground,
                backgroundColor: .cloudyDayBackground
            )
        case .cloudyEvening, .cloudyNight:
            return WeatherStyle(
                imageName: "cloudy-night",
                foregroundColor: .cloudyNightBackground,
                backgroundColor: .cloudyNightForeground
            )
        case .rainyMorning:
            return WeatherStyle(
                imageName: "rain-morning",
                foregroundColor: .rainyMorningBackground,
                backgroundColor: .rainyMorningForeground
            )
        case .rainyDay:
            return WeatherStyle(
                imageName: "rain-day",
                foregroundColor: .rainyDayBackground,
                backgroundColor: .rainyDayForeground
            )
        case .rainyNight:
            return WeatherStyle(
                imageName: "rain-night",
                foregroundColor: .rainyNightBackground,
                backgroundColor: .rainyNightForeground
            )
            
        case .snowyDay:
            return WeatherStyle(
                imageName: "snow-day",
                foregroundColor: .snowyDayBackground,
                backgroundColor: .snowyDayForeground
            )
        case .snowyNight:
            return WeatherStyle(
                imageName: "snow-night",
                foregroundColor: .snowyNightBackground,
                backgroundColor: .snowyNightForeground
            )
        default:
            return WeatherStyle(
                imageName: "snow-day",
                foregroundColor: .snowyDayBackground,
                backgroundColor: .snowyDayForeground
            )
        }
    }
}

struct Weather : Codable {
    struct Current : Codable {
        var time: String
        var temperature_2m: Double
        var is_day: Int
        var relative_humidity_2m: Double
        var weather_code: Int
        var wind_direction_10m: Double
        var wind_speed_10m: Double
    }
    struct Status : Codable {
        var statusText: String?
        var statusIcon: String?
        var generalStatus: String?
    }
    var current: Current
    var status: Status?
}

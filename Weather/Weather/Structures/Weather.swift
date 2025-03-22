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
                foregroundColor: .sunnyMorningForeground,
                backgroundColor: .sunnyMorningBackground
            )
        case .sunnyDay:
            return WeatherStyle(
                imageName: "sunny-day",
                foregroundColor: .sunnyDayForeground,
                backgroundColor: .sunnyDayBackground
            )
        case .sunnyEvening:
            return WeatherStyle(
                imageName: "sunny-evening",
                foregroundColor: .sunnyEveningForeground,
                backgroundColor: .sunnyEveningBackground
            )
        
        case .cloudyMorning:
            return WeatherStyle(
                imageName: "cloudy-morning",
                foregroundColor: .cloudyMorningForeground,
                backgroundColor: .cloudyMorningBackground
            )
        case .cloudyDay:
            return WeatherStyle(
                imageName: "cloudy-day",
                foregroundColor: .cloudyDayForeground,
                backgroundColor: .cloudyDayBackground
            )
        case .cloudyEvening, .cloudyNight:
            return WeatherStyle(
                imageName: "cloudy-night",
                foregroundColor: .cloudyNightForeground,
                backgroundColor: .cloudyNightBackground
            )
        case .rainyMorning:
            return WeatherStyle(
                imageName: "rain-morning",
                foregroundColor: .rainyMorningForeground,
                backgroundColor: .rainyMorningBackground
            )
        case .rainyDay:
            return WeatherStyle(
                imageName: "rain-day",
                foregroundColor: .rainyDayForeground,
                backgroundColor: .rainyDayBackground
            )
        case .rainyNight:
            return WeatherStyle(
                imageName: "rain-night",
                foregroundColor: .rainyNightForeground,
                backgroundColor: .rainyNightBackground
            )
            
        case .snowyDay:
            return WeatherStyle(
                imageName: "snow-day",
                foregroundColor: .snowyDayForeground,
                backgroundColor: .snowyDayBackground
            )
        case .snowyNight:
            return WeatherStyle(
                imageName: "snow-night",
                foregroundColor: .snowyNightForeground,
                backgroundColor: .snowyNightBackground
            )
        default:
            return WeatherStyle(
                imageName: "snow-day",
                foregroundColor: .snowyDayForeground,
                backgroundColor: .snowyDayBackground
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
        var apparent_temperature: Double
    }
    struct Status : Codable {
        var statusText: String?
        var statusIcon: String?
        var generalStatus: String?
    }
    var current: Current
    var status: Status?
}

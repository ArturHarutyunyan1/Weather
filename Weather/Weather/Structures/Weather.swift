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
        var wind_gusts_10m: Double
        var apparent_temperature: Double
        var precipitation: Double
    }
    struct Hourly : Codable {
        var time: [String]
        var temperature_2m: [Double]
        var weather_code: [Int]
        var wind_speed_10m: [Double]
        var relative_humidity_2m: [Int]
        var visibility: [Int]
    }
    struct Daily : Codable {
        var time: [String]
        var weather_code: [Int]
        var temperature_2m_max: [Double]
        var temperature_2m_min: [Double]
        var sunset: [String]
        var sunrise: [String]
        var uv_index_max: [Double]
    }
    struct Status : Codable {
        var statusText: String?
        var statusIcon: String?
        var generalStatus: String?
    }
    struct StatusArray: Codable {
        var statusText: [String]?
        var statusIcon: [String]?
        var generalStatus: [String]?
    }
    var current: Current
    var hourly: Hourly
    var daily: Daily
    var status: Status?
    var statusList: StatusArray?
    var dailyList: StatusArray?
}


func getMorningTimeBackground(for status: String) -> WeatherStyle {
    switch status {
    case "Clear": return WeatherBackground.sunnyMorning.style
    case "Cloudy": return WeatherBackground.cloudyMorning.style
    case "Rain": return WeatherBackground.rainyMorning.style
    case "Snow": return WeatherBackground.snowyDay.style
    default: return WeatherBackground.sunnyMorning.style
    }
}

func getDayTimeBackground(for status: String) -> WeatherStyle {
    switch status {
    case "Clear": return WeatherBackground.sunnyDay.style
    case "Cloudy": return WeatherBackground.cloudyDay.style
    case "Rain": return WeatherBackground.rainyDay.style
    case "Snow": return WeatherBackground.snowyDay.style
    default: return WeatherBackground.sunnyDay.style
    }
}

func getEveningTimeBackground(for status: String) -> WeatherStyle {
    switch status {
    case "Clear": return WeatherBackground.sunnyEvening.style
    case "Cloudy": return WeatherBackground.cloudyEvening.style
    case "Rain": return WeatherBackground.rainyNight.style
    case "Snow": return WeatherBackground.snowyNight.style
    default: return WeatherBackground.sunnyEvening.style
    }
}

func getNightTimeBackground(for status: String) -> WeatherStyle {
    switch status {
    case "Clear": return WeatherBackground.sunnyEvening.style
    case "Cloudy": return WeatherBackground.cloudyNight.style
    case "Rain": return WeatherBackground.rainyNight.style
    case "Snow": return WeatherBackground.snowyNight.style
    default: return WeatherBackground.sunnyEvening.style
    }
}

//
//  Weather.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

enum WeatherBackground: String {
    case sunrise, afternoon, evening, night
    case sunnyMorning, sunnyDay, sunnyEvening
    case cloudyMorning, cloudyDay, cloudyEvening, cloudyNight
    case rainyMorning, rainyDay, rainyNight
    case snowyDay, snowyNight
    
    var imageName: String {
        switch (self) {
        case .sunnyMorning:
            return "sunny-morning"
        case .sunnyDay:
            return "sunny-day"
        case .sunnyEvening:
            return "sunny-evening"
        
        case .cloudyMorning:
            return "cloudy-morning"
        case .cloudyDay:
            return "cloudy-day"
        case .cloudyEvening:
            return "cloudy-evening"
        case .cloudyNight:
            return "cloudy-night"
        
        case .rainyMorning:
            return "rain-morning"
        case .rainyDay:
            return "rain-day"
        case .rainyNight:
            return "rain-night"
            
        case .snowyDay:
            return "snow-day"
        case .snowyNight:
            return "snow-night"
        default:
            return ""
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

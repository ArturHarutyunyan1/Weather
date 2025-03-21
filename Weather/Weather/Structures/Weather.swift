//
//  Weather.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

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
    var current: Current
}

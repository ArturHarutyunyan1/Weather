//
//  Search.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct Search : Codable {
    struct Results : Codable {
        var id: Int
        var name: String
        var latitude: Double
        var longitude: Double
        var country_code: String
        var country: String
        var admin4: String?
    }
    var results: [Results]
}

struct ReverseGeocoding : Codable {
    struct Address : Codable {
        var city: String
        var country: String
    }
    var place_id: Int
    var address: Address
}

struct WeatherDetails : Identifiable, Hashable, Encodable, Decodable {
    var id: Int
    var city: String
    var country: String
    var admin4: String?
}

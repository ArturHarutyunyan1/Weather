//
//  Search.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

struct Results : Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var country_code: String
    var country: String
    var admin4: String?
    
}

struct Search : Codable {
    var results: [Results]
}

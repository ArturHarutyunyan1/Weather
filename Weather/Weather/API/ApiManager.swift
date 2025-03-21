//
//  ApiManager.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI
import Foundation
import MapKit

@MainActor
class ApiManager : ObservableObject {
    @Published var searchResults: [Search.Results] = []
    @Published var errorMessage: String?
    @Published var reversedResult: ReverseGeocoding? = nil
    @Published var weatherDetails: Weather? = nil
    
    @MainActor
    func searchQuery(query: String) async {
        let endpoint = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(query)&count=100&language=en&format=json")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                errorMessage = "Invalid response"
                return
            }
            guard response.statusCode == 200 else {
                self.errorMessage = response.statusCode == 404 ? "Not found" : "Something went wrong - \(response.statusCode)"
                return
            }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Search.self, from: data)
            
            self.searchResults = decodedData.results
        } catch {
            self.errorMessage = "Something went wrong"
        }
    }
    @MainActor
    func reverseGeocoding(lat: Double, lon: Double) async {
        let endpoint = URL(string: "https://nominatim.openstreetmap.org/reverse?lat=\(lat)&lon=\(lon)&format=json")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.errorMessage = "Invalid response"
                return
            }
            guard httpResponse.statusCode == 200 else {
                self.errorMessage = httpResponse.statusCode == 404 ? "Nothing found" : "Something went wrong"
                return
            }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ReverseGeocoding.self, from: data)
            
            self.reversedResult = decodedData
        } catch {
            self.errorMessage = "Something went wrong"
            return
        }
    }
    @MainActor
    func getWeatherDetails(latitude: Double, longitude: Double) async {
        let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,sunset,uv_index_clear_sky_max,sunrise&hourly=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m,visibility&current=temperature_2m,is_day,relative_humidity_2m,weather_code,wind_direction_10m,wind_speed_10m")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                self.errorMessage = "Something went wrong"
                return
            }
            guard response.statusCode == 200 else {
                self.errorMessage = response.statusCode == 404 ? "Nothing found" : "Something went wrong"
                return
            }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Weather.self, from: data)
            self.weatherDetails = decodedData
        } catch {
            self.errorMessage = "\(error.localizedDescription)"
        }
    }
}

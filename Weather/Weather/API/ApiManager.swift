//
//  ApiManager.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI
import Foundation
import MapKit

enum ApiError: Error {
    case invalidResponse
    case statusCodeError(Int)
    case decodingError
}


@MainActor
class ApiManager : ObservableObject {
    @Published var searchResults: [Search.Results] = []
    @Published var errorMessage: String?
    @Published var reversedResult: ReverseGeocoding? = nil
    @Published var weatherDetails: Weather? = nil
    
    func performRequest<T: Decodable>(endpoint: String, type: T.Type) async throws -> T {
        let url = URL(string: endpoint)!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw ApiError.statusCodeError(httpResponse.statusCode)
        }
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
    
    func handleError(_ error: Error) {
        if let apiError = error as? ApiError {
            switch (apiError) {
            case .invalidResponse:
                self.errorMessage = "Invalid response"
            case .statusCodeError(let code):
                self.errorMessage = "Error: \(code)"
            case .decodingError:
                self.errorMessage = "Something went wrong decoding the data"
            }
        }
    }
    
    @MainActor
    func searchQuery(query: String) async {
        do {
            searchResults = []
            let decodedData: Search = try await performRequest(endpoint: "https://geocoding-api.open-meteo.com/v1/search?name=\(query)&count=100&language=en&format=json", type: Search.self)
            self.searchResults = decodedData.results
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func reverseGeocoding(lat: Double, lon: Double) async {
        do {
            let decodedData: ReverseGeocoding = try await performRequest(endpoint: "https://nominatim.openstreetmap.org/reverse?lat=\(lat)&lon=\(lon)&format=json", type: ReverseGeocoding.self)
            self.reversedResult = decodedData
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func getWeatherDetails(latitude: Double, longitude: Double) async {
        do {
            let decodedData: Weather = try await performRequest(endpoint: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max,sunset,uv_index_clear_sky_max,sunrise&hourly=temperature_2m,weather_code,wind_speed_10m,relative_humidity_2m,visibility&current=apparent_temperature,temperature_2m,is_day,relative_humidity_2m,weather_code,wind_direction_10m,wind_speed_10m,wind_gusts_10m,precipitation&timezone=auto", type: Weather.self)
            self.weatherDetails = decodedData
            mapWeatherCodeToStatus((self.weatherDetails?.current?.weather_code)!, type: 0)
            setIcons()
        } catch {
            handleError(error)
        }
    }
    
    func mapWeatherCodeToStatus(_ code: Int, type: Int) {
        if weatherDetails?.status == nil {
            weatherDetails?.status = Weather.Status(statusText: nil, statusIcon: nil, generalStatus: nil)
        }
        
        let statusMapping: [Int: (String, String, String)] = [
            0: ("Clear sky", "sun.max.fill", "Clear"),
            1: ("Mainly clear", "cloud.sun.fill", "Clear"),
            2: ("Partly clear", "cloud.sun.fill", "Clear"),
            3: ("Cloudy", "cloud.fill", "Cloudy"),
            45: ("Fog", "cloud.fog.fill", "Clear"),
            48: ("Fog", "cloud.fog.fill", "Clear"),
            51: ("Light drizzle", "cloud.drizzle.fill", "Rain"),
            53: ("Moderate drizzle", "cloud.drizzle.fill", "Rain"),
            55: ("Heavy drizzle", "cloud.drizzle.fill", "Rain"),
            61: ("Light rain", "cloud.rain.fill", "Rain"),
            63: ("Moderate rain", "cloud.rain.fill", "Rain"),
            65: ("Heavy rain", "cloud.rain.fill", "Rain"),
            71: ("Light snow", "cloud.snow.fill", "Snow"),
            73: ("Moderate snow", "cloud.snow.fill", "Snow"),
            75: ("Heavy snow", "cloud.snow.fill", "Snow"),
            80: ("Light showers", "cloud.rain.fill", "Rain"),
            81: ("Moderate showers", "cloud.rain.fill", "Rain"),
            82: ("Heavy showers", "cloud.rain.fill", "Rain"),
            85: ("Light snow showers", "cloud.snow.fill", "Snow"),
            86: ("Heavy snow showers", "cloud.snow.fill", "Snow")
        ]
        if let status = statusMapping[code] {
            if type == 0 {
                weatherDetails?.status?.statusText = status.0
                weatherDetails?.status?.statusIcon = status.1
                weatherDetails?.status?.generalStatus = status.2
            } else {
                var statusArray = Weather.StatusArray(statusText: [], statusIcon: [], generalStatus: [])
                if type == 1 {
                    for code in weatherDetails?.hourly?.weather_code ?? [] {
                        if let status = statusMapping[code] {
                            statusArray.statusText?.append(status.0)
                            statusArray.statusIcon?.append(status.1)
                            statusArray.generalStatus?.append(status.2)
                        }
                    }
                    weatherDetails?.statusList = statusArray
                } else {
                    for code in weatherDetails?.daily?.weather_code ?? [] {
                        if let status = statusMapping[code] {
                            statusArray.statusText?.append(status.0)
                            statusArray.statusIcon?.append(status.1)
                            statusArray.generalStatus?.append(status.2)
                        }
                    }
                }
                weatherDetails?.dailyList = statusArray
            }
        } else {
            weatherDetails?.status?.statusText = "Unknown"
            weatherDetails?.status?.statusIcon = "questionmark.circle"
            weatherDetails?.status?.generalStatus = "Unknown"
        }
    }
    func setIcons() {
        for index in weatherDetails?.hourly?.weather_code ?? [] {
            mapWeatherCodeToStatus(index, type: 1)
        }
        for index in weatherDetails?.daily?.weather_code ?? [] {
            mapWeatherCodeToStatus(index, type: 2)
        }
    }
}

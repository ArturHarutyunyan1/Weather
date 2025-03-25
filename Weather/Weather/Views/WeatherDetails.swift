//
//  WeatherDetails.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct WeatherDetailsView: View {
    var weather: Weather
    @State private var isActive: Bool = false
    @State private var weatherStyle: WeatherStyle = WeatherBackground.cloudyDay.style
    @State private var fullDate: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @EnvironmentObject var apiManager: ApiManager
    var body: some View {
        ZStack {
            weatherStyle.backgroundColor.edgesIgnoringSafeArea(.all)
            Image(weatherStyle.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .opacity(isActive ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.3), value: isActive)
            
            if isActive {
                ScrollView {
                    VStack {
                        if let icon = weather.status?.statusIcon,
                           let temperature = weather.current?.temperature_2m,
                           let status = weather.status?.generalStatus,
                           let apparent = weather.current?.apparent_temperature,
                           let wind = weather.current?.wind_speed_10m {
                            CurrentWeather(
                                icon: icon,
                                temperature: temperature,
                                status: status,
                                apparent: apparent,
                                city: city,
                                country: country,
                                wind: wind,
                                weatherStyle: weatherStyle,
                                date: fullDate
                            )
                        }
                        if let hourly = weather.hourly,
                           let currentDate = weather.current?.time.split(separator: "T").first {
                            HourlyWeather(hourly: hourly, statusList: weather.statusList, currentDate: String(currentDate))
                        }
                        if let daily = weather.daily {
                            DailyForecast(daily: daily, statusList: weather.statusList, weatherStyle: weatherStyle)
                        }
                        if let wind = weather.current?.wind_speed_10m,
                           let gusts = weather.current?.wind_gusts_10m,
                           let direction = weather.current?.wind_direction_10m {
                            Wind(windSpeed: wind, windDirection: direction, gusts: gusts, weatherStyle: weatherStyle)
                        }
                        HStack {
                            if let temp = weather.current?.apparent_temperature {
                                FeelsLike(temp: temp)
                            }
                            if let index = weather.daily?.uv_index_max.first {
                                UVIndex(index: index)
                            }
                        }
                        HStack {
                            if let time = weather.daily?.sunset.first?.split(separator: "T").last {
                                Sunset(time: String(time))
                            }
                            if let time = weather.daily?.sunrise.first?.split(separator: "T").last {
                                Sunrise(time: String(time))
                            }
                        }
                        HStack {
                            if let visibility = weather.hourly?.visibility.first {
                                Visibility(distance: visibility)
                            }
                            if let humidity = weather.current?.relative_humidity_2m {
                                Humidity(humidity: Int(humidity))
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
                .scrollIndicators(.hidden)
                .padding(.vertical, 30)
                .frame(height: UIScreen.main.bounds.height)
                .navigationBarBackButtonHidden(false)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
                isActive = true
            }
            if let cityName = apiManager.weatherDetails?.locationInfo?.city,
               let countryName = apiManager.weatherDetails?.locationInfo?.country {
                city = cityName
                country = countryName
            } else {
                city = apiManager.reversedResult?.address.city ?? "Unknown"
                country = apiManager.reversedResult?.address.country ?? "Unknown"
            }
            getTimeOfTheDay()
        }
    }
    
    func getTimeOfTheDay() {
        guard let time = weather.current?.time.split(separator: "T").last,
              let hours = Int(time.split(separator: ":").first ?? "") else { return }
        guard let date = weather.current?.time.split(separator: "T").first else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObject = dateFormatter.date(from: String(date)) else { return }
        
        dateFormatter.dateStyle = .full
        fullDate = dateFormatter.string(from: dateObject) + " \(time)"
        
        weatherStyle = getBackgroundImage(for: hours, weather: weather)
    }
}

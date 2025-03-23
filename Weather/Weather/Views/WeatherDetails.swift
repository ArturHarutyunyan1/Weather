//
//  WeatherDetails.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct WeatherDetailsView: View {
    var weather: Weather
    @EnvironmentObject private var apiManager: ApiManager
    @State private var isActive: Bool = false
    @State private var weatherStyle: WeatherStyle = WeatherBackground.cloudyDay.style
    @State private var fullDate: String = ""
    
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
                        if let icon = apiManager.weatherDetails?.status?.statusIcon,
                           let temperature = apiManager.weatherDetails?.current.temperature_2m,
                           let status = apiManager.weatherDetails?.status?.generalStatus,
                           let city = apiManager.reversedResult?.address.city,
                           let country = apiManager.reversedResult?.address.country,
                           let apparent = apiManager.weatherDetails?.current.apparent_temperature,
                           let wind = apiManager.weatherDetails?.current.wind_speed_10m {
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
                        if let hourly = apiManager.weatherDetails?.hourly,
                           let currentDate = apiManager.weatherDetails?.current.time.split(separator: "T").first {
                            HourlyWeather(hourly: hourly, statusList: apiManager.weatherDetails?.statusList, currentDate: String(currentDate))
                        }
                        if let daily = apiManager.weatherDetails?.daily {
                            DailyForecast(daily: daily, statusList: apiManager.weatherDetails?.statusList, weatherStyle: weatherStyle)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .scrollIndicators(.hidden)
                .padding(.vertical, 30)
                .frame(height: UIScreen.main.bounds.height)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
                isActive = true
            }
            getTimeOfTheDay()
        }
    }
    
    func getTimeOfTheDay() {
        guard let time = weather.current.time.split(separator: "T").last,
              let hours = Int(time.split(separator: ":").first ?? "") else { return }
        guard let date = weather.current.time.split(separator: "T").first else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObject = dateFormatter.date(from: String(date)) else { return }
        
        dateFormatter.dateStyle = .full
        fullDate = dateFormatter.string(from: dateObject) + " \(time)"
        
        weatherStyle = getBackgroundImage(for: hours)
    }
    
    func getBackgroundImage(for hour: Int) -> WeatherStyle {
        let status = weather.status?.generalStatus ?? "Clear"
        switch hour {
        case 6...18:
            return getMorningTimeBackground(for: status)
        case 12...18:
            return getDayTimeBackground(for: status)
        case 18...21:
            return getEveningTimeBackground(for: status)
        case 21...23, 0...5:
            return getNightTimeBackground(for: status)
        default:
            return getDayTimeBackground(for: status)
        }
    }
}

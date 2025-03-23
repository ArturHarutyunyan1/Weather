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
                            VStack {
                                VStack {
                                    Text("Currently")
                                        .font(.custom("Poppins-Medium", size: 23))
                                }
                                .padding()
                                
                                VStack {
                                    HStack {
                                        Image(systemName: icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 73.61, height: 55.79)
                                        Text("\(temperature, specifier: "%.1f")°")
                                            .font(.custom("Poppins-Medium", size: 73))
                                    }
                                    VStack {
                                        Text("\(status)")
                                            .font(.custom("Poppins-Medium", size: 20))
                                    }
                                    VStack {
                                        Text("\(city), \(country)")
                                    }
                                    VStack {
                                        Text("\(fullDate)")
                                    }
                                    VStack {
                                        HStack {
                                            Text("Feels like \(apparent, specifier: "%.1f")°")
                                            Text("|")
                                            HStack {
                                                Image(systemName: "wind")
                                                Text("\(wind, specifier: "%.1f")km/h")
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 10)
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .background(weatherStyle.backgroundColor)
                            .foregroundStyle(weatherStyle.foregroundColor)
                            .cornerRadius(20)
                            if let hourly = apiManager.weatherDetails?.hourly {
                                if let currentDate = apiManager.weatherDetails?.current.time.split(separator: "T").first {
                                    let filteredIndices = hourly.time.indices.filter {
                                        hourly.time[$0].split(separator: "T").first == currentDate
                                    }
                                    ScrollView (.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach (filteredIndices, id: \.self) {index in
                                                VStack {
                                                    if let time = hourly.time[index].split(separator: "T").last?.split(separator: ":").first {
                                                        Text("\(time)")
                                                        if let icon = apiManager.weatherDetails?.statusList?.statusIcon?[index] {
                                                            Image(systemName: icon)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 30, height: 30)
                                                        }
                                                        Text("\(hourly.temperature_2m[index], specifier: "%.1f")°")
                                                        if let status = apiManager.weatherDetails?.statusList?.generalStatus?[index] {
                                                            Text("\(status)")
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal, 10)
                                            }
                                        }
                                        .padding()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(20)
                                }
                            }
                            if let daily = apiManager.weatherDetails?.daily {
                                VStack {
                                    ForEach(daily.time.indices, id:\.self) {index in
                                        HStack {
                                            Text("Mon")
                                            if let icon = apiManager.weatherDetails?.dailyList?.statusIcon?[index] {
                                                Image(systemName: icon)
                                            }
                                            if let min = apiManager.weatherDetails?.daily.temperature_2m_min[index],
                                               let max = apiManager.weatherDetails?.daily.temperature_2m_max[index] {
                                                Text("\(min, specifier: "%.1f")°")
                                                VStack {
                                                    ProgressView("", value: min, total: max)
                                                        .tint(weatherStyle.backgroundColor)
                                                    Spacer()
                                                    Spacer()
                                                }
                                                Text("\(max, specifier: "%.1f")°")
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                            }
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
            setIcons()
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
    func setIcons() {
        for index in apiManager.weatherDetails?.hourly.weather_code ?? [] {
            apiManager.mapWeatherCodeToStatus(index, type: 1)
        }
        for index in apiManager.weatherDetails?.daily.weather_code ?? [] {
            apiManager.mapWeatherCodeToStatus(index, type: 2)
        }
    }
}

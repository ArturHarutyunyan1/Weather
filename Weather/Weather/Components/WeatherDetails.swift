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
                VStack {
//                    Current weather info
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
                                    Image(systemName: apiManager.weatherDetails?.status?.statusIcon ?? "question.mark")
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
                                    Text("\(city),\(country)")
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
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).delay(0.1)) {
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

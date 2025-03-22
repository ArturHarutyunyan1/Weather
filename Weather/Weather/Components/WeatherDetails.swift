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
    @State private var weatherStyle: WeatherStyle = WeatherBackground.sunnyDay.style
    @State private var fullDate: String = ""
    var body: some View {
        GeometryReader {geometry in
            VStack {
                ZStack {
                    if isActive {
                        Image(weatherStyle.imageName)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            ScrollView {
                                VStack {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Image(systemName: (apiManager.weatherDetails?.status?.statusIcon)!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                            Text("\((apiManager.weatherDetails?.current.temperature_2m)!, specifier: "%.1f")°")
                                                .font(.custom("Poppins-Medium", size: 80))
                                                .fontWeight(.medium)
                                        }
                                        Spacer()
                                            .frame(height: 30)
                                        Text("\((apiManager.weatherDetails?.status?.statusText)!)")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                        Spacer()
                                            .frame(height: 20)
                                        Text("\((apiManager.reversedResult?.address.city)!), \((apiManager.reversedResult?.address.country)!)")
                                        Spacer()
                                            .frame(height: 30)
                                        Text("\(fullDate)")
                                            .font(.system(size: 15))
                                        Spacer()
                                            .frame(height: 20)
                                        Text("Feels like \((apiManager.weatherDetails?.current.apparent_temperature)!, specifier: "%.1f")")
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width * 0.9)
                                    .frame(maxHeight: 350)
                                    .background(weatherStyle.backgroundColor)
                                    .foregroundStyle(weatherStyle.foregroundColor)
                                    .cornerRadius(15)
                                }
                                .padding()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.7)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(weatherStyle.backgroundColor)
            }
        }
        .transition(.opacity)
        .onAppear {
            Task {
                getTimeOfTheDay()
            }
            withAnimation(.easeIn(duration: 0.3).delay(0.5)) {
                isActive = true
            }
        }
    }
    func getTimeOfTheDay() {
        guard let time = weather.current.time.split(separator: "T").last,
              let hours = Int(time.split(separator: ":").first ?? "") else {return}
        guard let date = weather.current.time.split(separator: "T").first else {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: String(date)) else {return}
        
        dateFormatter.dateStyle = .full
        fullDate = dateFormatter.string(from: date)
        fullDate += " \(time)"
        print(fullDate)
        weatherStyle = getBackgroundImage(for: hours)
    }
    func getBackgroundImage(for hour: Int) -> WeatherStyle {
        let status = weather.status?.generalStatus ?? "Clear"
        
        switch (hour) {
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
    func getMorningTimeBackground(for status: String) -> WeatherStyle {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyMorning.style
        case "Cloudy":
            return WeatherBackground.cloudyMorning.style
        case "Rain":
            return WeatherBackground.rainyMorning.style
        case "Snow":
            return WeatherBackground.snowyDay.style
        default:
            return WeatherBackground.sunnyMorning.style
        }
    }
    func getDayTimeBackground(for status: String) -> WeatherStyle {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyDay.style
        case "Cloudy":
            return WeatherBackground.cloudyDay.style
        case "Rain":
            return WeatherBackground.rainyDay.style
        case "Snow":
            return WeatherBackground.snowyDay.style
        default:
            return WeatherBackground.sunnyDay.style
        }
    }
    func getEveningTimeBackground(for status: String) -> WeatherStyle {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyEvening.style
        case "Cloudy":
            return WeatherBackground.cloudyEvening.style
        case "Rain":
            return WeatherBackground.rainyNight.style
        case "Snow":
            return WeatherBackground.snowyNight.style
        default:
            return WeatherBackground.sunnyEvening.style
        }
    }
    func getNightTimeBackground(for status: String) -> WeatherStyle {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyEvening.style
        case "Cloudy":
            return WeatherBackground.cloudyNight.style
        case "Rain":
            return WeatherBackground.rainyNight.style
        case "Snow":
            return WeatherBackground.snowyNight.style
        default:
            return WeatherBackground.sunnyEvening.style
        }
    }
}


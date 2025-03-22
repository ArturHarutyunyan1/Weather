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
    @State private var backgroundImage: String = ""
    @State private var isActive: Bool = false
    @State private var weatherStyle: WeatherStyle = WeatherBackground.sunnyDay.style
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                if isActive {
                    Image(weatherStyle.imageName)
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    Text("\(weatherStyle.imageName)")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(weatherStyle.backgroundColor)
            .foregroundStyle(weatherStyle.foregroundColor)
        }
        .transition(.opacity)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                getTimeOfTheDay()
            }
            Task {
                withAnimation (.easeIn(duration: 0.5).delay(0.3)){
                    isActive = true
                }
            }
        }
    }
    func getTimeOfTheDay() {
        guard let time = weather.current.time.split(separator: "T").last,
              let hours = Int(time.split(separator: ":").first ?? "") else {return}
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


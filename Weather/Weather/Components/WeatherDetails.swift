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
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                if isActive {
                    Image(backgroundImage)
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    Text("\(backgroundImage)")
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.blue)
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
        backgroundImage = getBackgroundImage(for: hours)
    }
    func getBackgroundImage(for hour: Int) -> String {
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
    func getMorningTimeBackground(for status: String) -> String {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyMorning.imageName
        case "Cloudy":
            return WeatherBackground.cloudyMorning.imageName
        case "Rain":
            return WeatherBackground.rainyMorning.imageName
        case "Snow":
            return WeatherBackground.snowyDay.imageName
        default:
            return WeatherBackground.sunnyMorning.imageName
        }
    }
    func getDayTimeBackground(for status: String) -> String {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyDay.imageName
        case "Cloudy":
            return WeatherBackground.cloudyDay.imageName
        case "Rain":
            return WeatherBackground.rainyDay.imageName
        case "Snow":
            return WeatherBackground.snowyDay.imageName
        default:
            return WeatherBackground.sunnyDay.imageName
        }
    }
    func getEveningTimeBackground(for status: String) -> String {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyEvening.imageName
        case "Cloudy":
            return WeatherBackground.cloudyEvening.imageName
        case "Rain":
            return WeatherBackground.rainyNight.imageName
        case "Snow":
            return WeatherBackground.snowyNight.imageName
        default:
            return WeatherBackground.sunnyEvening.imageName
        }
    }
    func getNightTimeBackground(for status: String) -> String {
        switch (status) {
        case "Clear":
            return WeatherBackground.sunnyEvening.imageName
        case "Cloudy":
            return WeatherBackground.cloudyNight.imageName
        case "Rain":
            return WeatherBackground.rainyNight.imageName
        case "Snow":
            return WeatherBackground.snowyNight.imageName
        default:
            return WeatherBackground.sunnyEvening.imageName
        }
    }
}


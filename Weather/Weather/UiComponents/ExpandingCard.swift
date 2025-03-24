//
//  ExpandingCard.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct CardView: View {
    @Binding var weather: Weather?
    var item: Weather
    let animation: Namespace.ID
    @State private var weatherStyle: WeatherStyle = WeatherBackground.rainyDay.style
    @State private var a: String = ""
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(weatherStyle.backgroundColor)
            }
            .matchedGeometryEffect(id: item.locationInfo?.id, in: animation)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 150)
            .overlay(
                HStack {
                    if let icon = item.status?.statusIcon,
                       let temperature = item.current?.temperature_2m,
                       let status = item.status?.generalStatus,
                       let city = item.locationInfo?.city,
                       let country = item.locationInfo?.country {
                        VStack {
                            Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text("\(status)")
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(temperature, specifier: "%.1f")°")
                                        .font(.custom("Poppins-Medium", size: 30))
                                }
                                HStack {
                                    Spacer()
                                    Text("\(country), \(city)")
                                }
                            }
                        }
                    }
                }
                    .foregroundStyle(weatherStyle.foregroundColor)
                    .padding()
            )
        }
        .onTapGesture {
            withAnimation {
                weather = item
            }
        }
        .onAppear {
            if let time = item.current?.time.split(separator: "T").last?.split(separator: ":").first {
                weatherStyle = getBackgroundImage(for: Int(time)!, weather: item)
            }
        }

    }
}

struct ExpandedCard: View {
    @Binding var weather: Weather?
    var item: Weather
    let animation: Namespace.ID
    @State private var weatherStyle: WeatherStyle = WeatherBackground.rainyDay.style
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                WeatherDetailsView(weather: item)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .matchedGeometryEffect(id: item.locationInfo?.id, in: animation)
            .background(weatherStyle.backgroundColor)
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            weather = nil
        }
        .onAppear {
            if let time = item.current?.time.split(separator: "T").last?.split(separator: ":").first {
                weatherStyle = getBackgroundImage(for: Int(time)!, weather: item)
            }
        }
    }
}


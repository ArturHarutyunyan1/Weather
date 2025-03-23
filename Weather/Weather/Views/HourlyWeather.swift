//
//  HourlyWeather.swift
//  Weather
//
//  Created by Artur Harutyunyan on 23.03.25.
//

import SwiftUI

struct HourlyWeather: View {
    let hourly: Weather.Hourly
    let statusList: Weather.StatusArray?
    let currentDate: String

    var body: some View {
        let filteredIndices = hourly.time.indices.filter {
            hourly.time[$0].split(separator: "T").first ?? "" == currentDate
        }

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filteredIndices, id: \.self) { index in
                    VStack {
                        if let time = hourly.time[index].split(separator: "T").last?.split(separator: ":").first {
                            Text("\(time)")
                                .font(.custom("Poppins-Medium", size: 16))
                        }
                        if let icon = statusList?.statusIcon?[index] {
                            Image(systemName: icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        Text("\(hourly.temperature_2m[index], specifier: "%.1f")°")
                            .font(.custom("Poppins-Medium", size: 18))
                        if let status = statusList?.generalStatus?[index] {
                            Text("\(status)")
                                .font(.custom("Poppins-Regular", size: 14))
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

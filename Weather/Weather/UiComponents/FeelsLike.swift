//
//  FeelsLike.swift
//  Weather
//
//  Created by Artur Harutyunyan on 24.03.25.
//

import SwiftUI

struct FeelsLike: View {
    let temp: Double
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "thermometer.sun")
                Text("Feels like")
                Spacer()
            }
            Text("\(temp, specifier: "%.1f")°")
                .font(.custom("Poppins-Medium", size: 50))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.45, height: 150)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

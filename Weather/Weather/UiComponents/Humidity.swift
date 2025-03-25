//
//  Humidity.swift
//  Weather
//
//  Created by Artur Harutyunyan on 25.03.25.
//

import SwiftUI

struct Humidity: View {
    let humidity: Int
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "humidity")
                Text("Humidity")
                Spacer()
            }
            Text("\(humidity)%")
                .font(.custom("Poppins-Medium", size: 40))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.45, height: 150)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

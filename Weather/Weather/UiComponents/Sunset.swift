//
//  Sunset.swift
//  Weather
//
//  Created by Artur Harutyunyan on 25.03.25.
//

import SwiftUI

struct Sunset: View {
    let time: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "sunset")
                Text("Sunset")
                Spacer()
            }
            Text("\(time)")
                .font(.custom("Poppins-Medium", size: 40))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.45, height: 150)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

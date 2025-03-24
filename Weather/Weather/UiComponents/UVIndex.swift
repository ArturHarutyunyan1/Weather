//
//  UVIndex.swift
//  Weather
//
//  Created by Artur Harutyunyan on 24.03.25.
//

import SwiftUI

struct UVIndex: View {
    let index: Double
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "sun.max.fill")
                Text("UV Index")
                Spacer()
            }
            Text("\(index, specifier: "%.1f")")
                .font(.custom("Poppins-Medium", size: 50))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.45, height: 150)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}


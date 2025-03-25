//
//  Visibility.swift
//  Weather
//
//  Created by Artur Harutyunyan on 25.03.25.
//

import SwiftUI

struct Visibility: View {
    let distance: Int
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "eye")
                Text("Visibility")
                Spacer()
            }
            Text("\(distance / 1000)km")
                .font(.custom("Poppins-Medium", size: 40))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.45, height: 150)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}



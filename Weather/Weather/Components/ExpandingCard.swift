//
//  ExpandingCard.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI


struct ExpandingCard: View {
    @State private var currentWeather: WeatherDetails? = nil
    @State private var isExpanded: Bool = false
    
//    let details: [WeatherDetails] = [
//        WeatherDetails(id: 0, name: "Yerevan", city: "Armenia", color: .orange),
//        WeatherDetails(id: 1, name: "Paris", city: "France", color: .blue),
//    ]
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ExpandingCard()
}

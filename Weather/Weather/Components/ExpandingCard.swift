//
//  ExpandingCard.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI

struct CardView: View {
    @Binding var weather: WeatherDetails?
    var item: WeatherDetails
    let animation: Namespace.ID
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(item.color)
            }
            .matchedGeometryEffect(id: item.id, in: animation)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 150)
            HStack {
                VStack {
                    Text("\(item.city)")
                    Text("\(item.country)")
                }
                .font(.system(size: 42))
            }
        }
        .onTapGesture {
            weather = item
        }
    }
}

struct ExpandedCard: View {
    @Binding var weather: WeatherDetails?
    var item: WeatherDetails
    let animation: Namespace.ID
    var body: some View {
        GeometryReader {geometry in
            ZStack {
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(item.color)
            .matchedGeometryEffect(id: item.id, in: animation)
        }
        .transition(.opacity)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            Task {
                weather = nil
            }
        }
        .zIndex(999)
    }
}

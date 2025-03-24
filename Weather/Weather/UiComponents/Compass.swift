//
//  Compass.swift
//  Weather
//
//  Created by Artur Harutyunyan on 24.03.25.
//

import SwiftUI

struct CircularLayout: Layout {
    struct CacheData {
        var positions: [CGPoint] = []
        var itemSize: CGSize = .zero
    }
    typealias Cache = CacheData
    
    func makeCache(subviews: Subviews) -> CacheData {
        return CacheData()
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
        let diameter = min(proposal.width ?? 100, proposal.height ?? 100)
        let radius = (diameter / 2) * 0.8
        let center = CGPoint(x: diameter / 2, y: diameter / 2)
        let totalMarks = 12
        let gapIndices = [0, 3, 6, 9]
        let angleIncrement = (2 * CGFloat.pi) / CGFloat(totalMarks)
        
        cache.positions = []
        cache.itemSize = CGSize(width: diameter / 5, height: diameter / 5)
        
        for index in gapIndices {
            let angle = (-CGFloat.pi / 2) + (angleIncrement * CGFloat(index))
            let x = center.x + radius * cos(angle) - cache.itemSize.width / 2
            let y = center.y + radius * sin(angle) - cache.itemSize.height / 2
            cache.positions.append(CGPoint(x: x, y: y))
        }
        
        return CGSize(width: diameter, height: diameter)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
        for index in subviews.indices {
            let position = cache.positions[index]
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: ProposedViewSize(cache.itemSize)
            )
        }
    }
}


struct ClockMarks: View {
    let weatherStyle: WeatherStyle
    private let relativeLength: CGFloat = 0.1
    private let marksCount = 12
    private let gapIndices = [0, 3, 6, 9]
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = geometry.size.width / 2
            
            ForEach(0..<12) { index in
                if !gapIndices.contains(index) {
                    Path { path in
                        let angle = -CGFloat.pi / 2 + (2 * .pi / CGFloat(marksCount) * CGFloat(index))
                        let startX = center.x + (radius - (relativeLength * geometry.size.height)) * cos(angle)
                        let startY = center.y + (radius - (relativeLength * geometry.size.height)) * sin(angle)
                        let endX = center.x + radius * cos(angle)
                        let endY = center.y + radius * sin(angle)
                        
                        path.move(to: CGPoint(x: startX, y: startY))
                        path.addLine(to: CGPoint(x: endX, y: endY))
                    }
                    .stroke(Color(weatherStyle.foregroundColor), lineWidth: 2)
                }
            }
        }
        .frame(width: 100, height: 100)
    }
}


struct Compass: View {
    let symbols = ["N", "E", "S", "W"]
    let weatherStyle: WeatherStyle
    let direction: Double
    var body: some View {
        ZStack {
            Circle()
                .fill(weatherStyle.backgroundColor)
                .frame(width: 120, height: 120)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
            ClockMarks(weatherStyle: weatherStyle)
            CircularLayout() {
                ForEach(symbols, id: \.self) { item in
                    Text("\(item)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(weatherStyle.foregroundColor)
                        .frame(width: 20, height: 20)
                }
            }
            .frame(width: 100, height: 100)
            Image(systemName: "location.north.line.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(weatherStyle.foregroundColor)
                .rotationEffect(Angle(degrees: direction))
        }
        .frame(width: 100, height: 100)
    }
}

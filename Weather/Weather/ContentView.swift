//
//  ContentView.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {geometry in
            VStack {
                SearchView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

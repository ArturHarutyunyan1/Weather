//
//  ContentView.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject private var apiManager: ApiManager
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
    let apiManager = ApiManager()
    ContentView()
        .environmentObject(apiManager)
        .preferredColorScheme(.dark)
}

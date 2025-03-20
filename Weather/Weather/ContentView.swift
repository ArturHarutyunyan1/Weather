//
//  ContentView.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        GeometryReader {geometry in
            VStack {
                SearchView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.locationPermission()
            }
        }
    }
}

#Preview {
    let apiManager = ApiManager()
    ContentView()
        .environmentObject(apiManager)
        .preferredColorScheme(.dark)
}

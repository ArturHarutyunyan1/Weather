//
//  WeatherApp.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var APIManager = ApiManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(APIManager)
                .preferredColorScheme(.dark)
        }
    }
}

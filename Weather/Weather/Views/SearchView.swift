//
//  SearchView.swift
//  Weather
//
//  Created by Artur Harutyunyan on 20.03.25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if isFocused {
                    Text("Search")
                        .font(.title)
                        .padding()
                }
            }
            .searchable(text: $searchText, prompt: Text("Search"))
            .navigationTitle("Weather")
            .searchFocused($isFocused)
        }
    }
}


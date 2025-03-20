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
    @EnvironmentObject private var APIManager: ApiManager
    var body: some View {
        NavigationView {
            VStack {
                if isFocused && searchText.count > 3 {
                    if !APIManager.searchResults.isEmpty {
                        ScrollView (.vertical, showsIndicators: false) {
                            ForEach(APIManager.searchResults, id: \.id) {result in
                                HStack {
                                    Button(action: {
                                        
                                    }, label: {
                                        Text("\(result.name), \(result.country)")
                                    })
                                    .foregroundStyle(.white)
                                    Spacer()
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                            }
                            Spacer()
                        }
                    } else {
                        Text("Nothing found")
                    }
                }
            }
            .searchable(text: $searchText, prompt: Text("Search"))
            .navigationTitle("Weather")
            .searchFocused($isFocused)
            .onChange(of: searchText) {newValue, _ in
                Task {
                    APIManager.fetchQuery(query: newValue)
                }
            }
        }
    }
}


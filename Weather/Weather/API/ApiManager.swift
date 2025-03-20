//
//  ApiManager.swift
//  Weather
//
//  Created by Artur Harutyunyan on 21.03.25.
//

import SwiftUI
import Foundation

class ApiManager : ObservableObject {
    @Published var searchResults: [Results] = []
    @Published var errorMessage: String?
    func fetchQuery(query: String) {
        let endpoint = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(query)&count=100&language=en&format=json")!
        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                print("Something went wrong - \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Something went wrong"
                }
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 404 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Nothing found"
                    }
                    return
                }
                if response.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Something went wrong"
                    }
                    return
                }
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Search.self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = decodedData.results
                        self.errorMessage = ""
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Something went wrong"
                    }
                }
            }
        }.resume()
    }
}

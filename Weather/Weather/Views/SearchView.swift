import SwiftUI
import MapKit

struct WeatherSearchResult: Identifiable, Codable {
    let id: String
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
}

struct SearchView: View {

    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    @EnvironmentObject private var apiManager: ApiManager
    @StateObject private var locationManager = LocationManager()
    @Binding var cities: [Weather]
    @Binding var searchedCity: Weather?
    
    @Namespace private var animation
    @State private var isSheetPresented: Bool = false
    @State private var selectedItem: Weather? = nil
    @State private var weatherStyle: WeatherStyle = WeatherBackground.cloudyDay.style
    
    private let citiesKey = "cities"
    
    var body: some View {
        ZStack {
            NavigationStack {
                Group {
                    if isSearchFocused {
                        searchResultsView
                    } else {
                        citiesListView
                    }
                }
                .navigationTitle("Weather")
                .searchable(text: $searchText, prompt: Text("Search"))
                .searchFocused($isSearchFocused)
                .onChange(of: searchText) { newValue, _ in
                    if newValue.count > 3 {
                        Task {
                            await apiManager.searchQuery(query: newValue)
                            if newValue.isEmpty {
                                apiManager.searchResults = []
                            }
                        }
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.90, blendDuration: 0.2),
                       value: selectedItem?.locationInfo?.id)
            
            if let selectedItem = selectedItem {
                ExpandedCard(weather: $selectedItem, item: selectedItem, animation: animation)
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            if let weather = searchedCity {
                WeatherDetailsView(weather: weather)
            }
        }
        .onAppear(perform: loadCities)
    }
    
    private var searchResultsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if let error = apiManager.errorMessage {
                Text("\(error)")
                    .foregroundStyle(.gray)
                    .padding()
            } else {
                ForEach(apiManager.searchResults as [Search.Results], id: \.id) { result in
                    HStack {
                        Button(action: { selectSearchResult(result) }) {
                            Text("\(result.name), \(result.country)")
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                }
            }
            Spacer()
        }
    }

    
    private var citiesListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(cities, id: \.locationInfo?.id) { city in
                CardView(weather: $selectedItem, item: city, animation: animation)
            }
        }
    }
    
    private func selectSearchResult(_ result: Search.Results) {
        Task {
            await apiManager.getWeatherDetails(latitude: result.latitude, longitude: result.longitude)
            if var weather = apiManager.weatherDetails {
                weather.locationInfo = Weather.LocationInfo(id: result.id, city: result.name, country: result.country)
                if !cities.contains(where: { $0.locationInfo?.id == result.id }) {
                    cities.append(weather)
                }
                saveCities()
                searchedCity = weather
                isSheetPresented = true
                isSearchFocused = false
            }
        }
    }
    
    private func loadCities() {
        if let savedData = UserDefaults.standard.data(forKey: citiesKey) {
            let decoder = JSONDecoder()
            if let decodedCities = try? decoder.decode([Weather].self, from: savedData) {
                cities = decodedCities
            }
        }
    }
    
    private func saveCities() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(cities) {
            UserDefaults.standard.set(encodedData, forKey: citiesKey)
        }
    }
}

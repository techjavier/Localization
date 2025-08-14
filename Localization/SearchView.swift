import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel

    var body: some View {
        let res = viewModel.results()
        List {
            if !res.countries.isEmpty {
                Section(String(localized: "Countries", comment: "Countries results")) {
                    ForEach(res.countries) { country in
                        NavigationLink(country.name) {
                            CityListView(country: country)
                        }
                    }
                }
            }
            if !res.cities.isEmpty {
                Section(String(localized: "Cities", comment: "Cities results")) {
                    ForEach(res.cities) { city in
                        if let country = viewModel.countries.first(where: { $0.cities.contains(city) }) {
                            NavigationLink(city.name) {
                                CityDetailView(city: city, country: country)
                            }
                        }
                    }
                }
            }
            if !res.landmarks.isEmpty {
                Section(String(localized: "Landmarks", comment: "Landmarks results")) {
                    ForEach(res.landmarks) { landmark in
                        NavigationLink(landmark.name) {
                            LandmarkDetailView(landmark: landmark)
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "Search", comment: "Search navigation title"))
        .searchable(text: $viewModel.query, prompt: String(localized: "Search places", comment: "Search placeholder"))
    }
}

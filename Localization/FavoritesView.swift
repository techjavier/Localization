import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        List {
            if !favorites.cities.isEmpty {
                Section(String(localized: "Cities", comment: "Favorite cities")) {
                    ForEach(favorites.cities) { city in
                        if let country = SampleData.countries.first(where: { $0.cities.contains(city) }) {
                            NavigationLink(city.name) {
                                CityDetailView(city: city, country: country)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    favorites.toggle(city: city)
                                } label: {
                                    Label(String(localized: "Remove", comment: "Remove favorite"), systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            if !favorites.landmarks.isEmpty {
                Section(String(localized: "Landmarks", comment: "Favorite landmarks")) {
                    ForEach(favorites.landmarks) { landmark in
                        NavigationLink(landmark.name) {
                            LandmarkDetailView(landmark: landmark)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                favorites.toggle(landmark: landmark)
                            } label: {
                                Label(String(localized: "Remove", comment: "Remove favorite"), systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(String(localized: "Favorites", comment: "Favorites navigation title"))
    }
}

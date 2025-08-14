import SwiftUI

struct CityDetailView: View {
    let city: City
    let country: Country
    @EnvironmentObject private var favorites: FavoritesStore

    var currency: Currency? { SampleData.currency(for: country.currencyCode) }

    var weatherSymbol: String {
        switch city.weather.condition {
        case "Sunny": return "sun.max.fill"
        case "Partly Cloudy": return "cloud.sun.fill"
        case "Cloudy": return "cloud.fill"
        case "Rain": return "cloud.rain.fill"
        case "Windy": return "wind"
        default: return "questionmark"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Style.padding) {
                HStack {
                    Text(city.name)
                        .font(.largeTitle)
                        .bold()
                    TagBadge(text: country.isoCode)
                }
                Text(city.shortDescription)
                InfoRow(
                    icon: weatherSymbol,
                    title: String(localized: "Current", comment: "Current weather label"),
                    value: "\(Int(city.weather.temperatureC))°C · \(city.weather.condition)"
                )
                // TODO: Plug real weather API
                if let currency = currency {
                    InfoRow(
                        icon: "dollarsign.circle",
                        title: String(localized: "Currency", comment: "Currency info label"),
                        value: "\(currency.symbol) • ~\(String(format: "%.2f", currency.sampleUsdRate)) " + String(localized: "per USD", comment: "per USD tail")
                    )
                    // TODO: Plug real FX API
                }
                Text(String(localized: "Landmarks", comment: "Landmarks section header"))
                    .font(.title2)
                ForEach(city.landmarks) { landmark in
                    NavigationLink {
                        LandmarkDetailView(landmark: landmark)
                    } label: {
                        Card {
                            Text(landmark.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                Button {
                    favorites.toggle(city: city)
                } label: {
                    Text(favorites.cities.contains(city) ? String(localized: "Remove from Favorites", comment: "Remove city favorite button") : String(localized: "Add to Favorites", comment: "Add city favorite button"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel(favorites.cities.contains(city) ? String(localized: "Remove from Favorites", comment: "Remove city favorite button") : String(localized: "Add to Favorites", comment: "Add city favorite button"))
            }
            .padding(Style.padding)
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LandmarkDetailView: View {
    let landmark: Landmark
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        VStack(alignment: .leading, spacing: Style.padding) {
            Text(landmark.name)
                .font(.largeTitle)
                .bold()
            Text(landmark.blurb)
            Button {
                favorites.toggle(landmark: landmark)
            } label: {
                Text(favorites.landmarks.contains(landmark) ? String(localized: "Remove from Favorites", comment: "Remove landmark favorite button") : String(localized: "Add to Favorites", comment: "Add landmark favorite button"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(favorites.landmarks.contains(landmark) ? String(localized: "Remove from Favorites", comment: "Remove landmark favorite button") : String(localized: "Add to Favorites", comment: "Add landmark favorite button"))
            Spacer()
        }
        .padding(Style.padding)
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

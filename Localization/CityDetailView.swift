import SwiftUI

struct CityDetailView: View {
    let city: City
    let country: Country
    @EnvironmentObject private var favorites: FavoritesStore
    @State private var favoriteCount = 0

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

    var greeting: String {
        String(
            localized: "greeting.city",
            defaultValue: "Welcome to {city}!",
            comment: "Greeting line on City Detail that inserts the city name"
        ).replacingOccurrences(of: "{city}", with: city.name)
    }

    var favoritesLine: String {
        String(
            localized: "favorites.count.line",
            defaultValue: "You have {count} favorite landmarks in {city}.",
            comment: "Summary showing how many favorite landmarks the user has in a given city"
        )
        .replacingOccurrences(of: "{count}", with: "\(favoriteCount)")
        .replacingOccurrences(of: "{city}", with: city.name)
    }

    var weatherLine: String {
        let temp = Measurement(value: city.weather.temperatureC, unit: UnitTemperature.celsius)
        let mf = MeasurementFormatter(); mf.unitOptions = .providedUnit
        let tempString = mf.string(from: temp)
        return String(
            localized: "weather.summary",
            defaultValue: "{temp} · {condition}",
            comment: "Short weather summary line with temperature and condition"
        )
        .replacingOccurrences(of: "{temp}", with: tempString)
        .replacingOccurrences(of: "{condition}", with: String(localized: city.weather.condition, comment: "Weather condition word"))
    }

    var currencyLine: String? {
        guard let currency = currency else { return nil }
        let nf = NumberFormatter(); nf.numberStyle = .currency; nf.currencyCode = currency.code
        let rateString = nf.string(from: NSNumber(value: currency.sampleUsdRate)) ?? "\(currency.sampleUsdRate)"
        return String(
            localized: "currency.info",
            defaultValue: "{code} • ~{rate} per USD",
            comment: "Shows currency code and mock rate per USD"
        )
        .replacingOccurrences(of: "{code}", with: currency.code)
        .replacingOccurrences(of: "{rate}", with: rateString)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Style.padding) {
                Image("city")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 120)
                HStack {
                    Text(city.name)
                        .font(.largeTitle)
                        .bold()
                    TagBadge(text: country.isoCode)
                }
                Text(city.shortDescription)
                InfoRow(
                    icon: weatherSymbol,
                    title: String(localized: "weather.current", defaultValue: "Current", comment: "Current weather label"),
                    value: weatherLine
                )
                // TODO: Plug real weather API
                if let currencyLine = currencyLine {
                    InfoRow(
                        icon: "dollarsign.circle",
                        title: String(localized: "currency.title", defaultValue: "Currency", comment: "Currency info label"),
                        value: currencyLine
                    )
                    // TODO: Plug real FX API
                }
                Text(String(localized: "landmarks.section", defaultValue: "Landmarks", comment: "Landmarks section header"))

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
              
                VStack(alignment: .leading, spacing: 8) {
                    Text(greeting)
                    Text(favoritesLine).accessibilityLabel(String(localized: "favorites.count.accessibility", defaultValue: "Favorites Count Line", comment: "Accessibility label for favorites line"))

                    HStack {
                        Button(String(localized: "decrement", defaultValue: "−", comment: "Decrease count")) {
                            favoriteCount = max(0, favoriteCount - 1)
                        }
                        Button(String(localized: "increment", defaultValue: "+", comment: "Increase count")) {
                            favoriteCount += 1
                        }
                        Text(String(localized: "current.count", defaultValue: "Count: {count}", comment: "Shows current count")
                             .replacingOccurrences(of: "{count}", with: "\(favoriteCount)"))
                    }
                }
                .padding()
                Button {
                    favorites.toggle(city: city)
                } label: {
                    Text(
                        favorites.cities.contains(city) ?
                        String(localized: "favorites.remove.city", defaultValue: "Remove from Favorites", comment: "Remove city favorite button") :
                        String(localized: "favorites.add.city", defaultValue: "Add to Favorites", comment: "Add city favorite button")
                    )
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel(
                    favorites.cities.contains(city) ?
                        String(localized: "favorites.remove.city", defaultValue: "Remove from Favorites", comment: "Remove city favorite button") :
                        String(localized: "favorites.add.city", defaultValue: "Add to Favorites", comment: "Add city favorite button")
                )
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
                Text(
                    favorites.landmarks.contains(landmark) ?
                        String(localized: "favorites.remove.landmark", defaultValue: "Remove from Favorites", comment: "Remove landmark favorite button") :
                        String(localized: "favorites.add.landmark", defaultValue: "Add to Favorites", comment: "Add landmark favorite button")
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(
                favorites.landmarks.contains(landmark) ?
                    String(localized: "favorites.remove.landmark", defaultValue: "Remove from Favorites", comment: "Remove landmark favorite button") :
                    String(localized: "favorites.add.landmark", defaultValue: "Add to Favorites", comment: "Add landmark favorite button")
            )
            Spacer()
        }
        .padding(Style.padding)
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

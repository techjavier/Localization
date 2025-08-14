import Foundation

// MARK: - Models

struct Country: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let isoCode: String
    let continent: String
    let currencyCode: String
    let cities: [City]
}

struct City: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let shortDescription: String
    let landmarks: [Landmark]
    let weather: Weather
}

struct Landmark: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let blurb: String
}

struct Weather: Hashable {
    let temperatureC: Double
    let condition: String
}

struct Currency: Hashable {
    let code: String
    let symbol: String
    let sampleUsdRate: Double
}

// MARK: - Sample Data

enum SampleData {
    static let currencies: [Currency] = [
        Currency(code: "EUR", symbol: "€", sampleUsdRate: 1.07),
        Currency(code: "JPY", symbol: "¥", sampleUsdRate: 0.0071),
        Currency(code: "USD", symbol: "$", sampleUsdRate: 1.0)
    ]

    static let countries: [Country] = [
        Country(
            name: "Italy",
            isoCode: "IT",
            continent: "Europe",
            currencyCode: "EUR",
            cities: [
                City(
                    name: "Rome",
                    shortDescription: "Ancient city with rich history.",
                    landmarks: [
                        Landmark(name: "Colosseum", blurb: "Massive amphitheatre used for gladiatorial games."),
                        Landmark(name: "Trevi Fountain", blurb: "Iconic 18th-century fountain.")
                    ],
                    weather: Weather(temperatureC: 28, condition: "Sunny")
                ),
                City(
                    name: "Milan",
                    shortDescription: "Fashion capital of Italy.",
                    landmarks: [
                        Landmark(name: "Duomo di Milano", blurb: "Gothic cathedral with stunning architecture.")
                    ],
                    weather: Weather(temperatureC: 24, condition: "Partly Cloudy")
                )
            ]
        ),
        Country(
            name: "Japan",
            isoCode: "JP",
            continent: "Asia",
            currencyCode: "JPY",
            cities: [
                City(
                    name: "Tokyo",
                    shortDescription: "Vibrant capital blending tradition and technology.",
                    landmarks: [
                        Landmark(name: "Senso-ji", blurb: "Tokyo's oldest temple."),
                        Landmark(name: "Tokyo Tower", blurb: "Iconic broadcast and observation tower.")
                    ],
                    weather: Weather(temperatureC: 22, condition: "Cloudy")
                ),
                City(
                    name: "Kyoto",
                    shortDescription: "Historic city famous for shrines and temples.",
                    landmarks: [
                        Landmark(name: "Fushimi Inari", blurb: "Famous shrine with thousands of torii gates."),
                        Landmark(name: "Kiyomizu-dera", blurb: "Historic wooden temple on Mount Otowa.")
                    ],
                    weather: Weather(temperatureC: 20, condition: "Rain")
                )
            ]
        ),
        Country(
            name: "USA",
            isoCode: "US",
            continent: "North America",
            currencyCode: "USD",
            cities: [
                City(
                    name: "New York",
                    shortDescription: "The city that never sleeps.",
                    landmarks: [
                        Landmark(name: "Statue of Liberty", blurb: "Symbol of freedom on Liberty Island."),
                        Landmark(name: "Central Park", blurb: "Urban park offering green respite in Manhattan.")
                    ],
                    weather: Weather(temperatureC: 18, condition: "Windy")
                )
            ]
        )
    ]
}

extension SampleData {
    static func currency(for code: String) -> Currency? {
        currencies.first { $0.code == code }
    }
}


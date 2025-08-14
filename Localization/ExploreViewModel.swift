import Foundation

final class ExploreViewModel: ObservableObject {
    let countries: [Country]

    init(countries: [Country] = SampleData.countries) {
        self.countries = countries
    }

    var continents: [String] {
        Array(Set(countries.map { $0.continent })).sorted()
    }

    func countries(in continent: String) -> [Country] {
        countries.filter { $0.continent == continent }
    }
}

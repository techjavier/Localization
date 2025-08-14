import Foundation

final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    let countries: [Country]

    init(countries: [Country] = SampleData.countries) {
        self.countries = countries
    }

    func results(for text: String? = nil) -> (countries: [Country], cities: [City], landmarks: [Landmark]) {
        let q = (text ?? query).lowercased()
        guard !q.isEmpty else { return ([], [], []) }
        let countryMatches = countries.filter { $0.name.lowercased().contains(q) }
        let citiesAll = countries.flatMap { $0.cities }
        let cityMatches = citiesAll.filter { $0.name.lowercased().contains(q) }
        let landmarkMatches = citiesAll.flatMap { $0.landmarks }.filter { $0.name.lowercased().contains(q) }
        return (countryMatches, cityMatches, landmarkMatches)
    }
}

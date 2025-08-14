import SwiftUI

struct ExploreView: View {
    @ObservedObject var viewModel: ExploreViewModel

    var body: some View {
        List(viewModel.continents, id: \.self) { continent in
            NavigationLink(continent) {
                CountryListView(continent: continent, countries: viewModel.countries(in: continent))
            }
        }
        .navigationTitle(String(localized: "nav.explore", defaultValue: "Explore", comment: "Explore navigation title"))
    }
}

struct CountryListView: View {
    let continent: String
    let countries: [Country]

    var body: some View {
        List(countries) { country in
            NavigationLink(country.name) {
                CityListView(country: country)
            }
        }
        .navigationTitle(continent)
    }
}

struct CityListView: View {
    let country: Country

    var body: some View {
        List(country.cities) { city in
            NavigationLink(city.name) {
                CityDetailView(city: city, country: country)
            }
        }
        .navigationTitle(country.name)
    }
}

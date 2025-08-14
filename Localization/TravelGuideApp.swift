import SwiftUI

@main
struct TravelGuideApp: App {
    @StateObject private var favorites = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    ExploreView(viewModel: ExploreViewModel())
                }
                .tabItem {
                    Label(String(localized: "tab.explore", defaultValue: "Explore", comment: "Explore tab"), systemImage: "globe.europe.africa")
                }

                NavigationStack {
                    SearchView(viewModel: SearchViewModel())
                }
                .tabItem {
                    Label(String(localized: "tab.search", defaultValue: "Search", comment: "Search tab"), systemImage: "magnifyingglass")
                }

                NavigationStack {
                    FavoritesView()
                }
                .tabItem {
                    Label(String(localized: "tab.favorites", defaultValue: "Favorites", comment: "Favorites tab"), systemImage: "star.fill")
                }
            }
            .environmentObject(favorites)
        }
    }
}

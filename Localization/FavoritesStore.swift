import Foundation
import SwiftUI

final class FavoritesStore: ObservableObject {
    @Published var cities: [City] = []
    @Published var landmarks: [Landmark] = []

    func toggle(city: City) {
        if let index = cities.firstIndex(of: city) {
            cities.remove(at: index)
        } else {
            cities.append(city)
        }
    }

    func toggle(landmark: Landmark) {
        if let index = landmarks.firstIndex(of: landmark) {
            landmarks.remove(at: index)
        } else {
            landmarks.append(landmark)
        }
    }
}

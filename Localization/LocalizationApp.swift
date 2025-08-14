//
//  LocalizationApp.swift
//  Localization
//
//  Created by Javier Fransiscus on 13/08/25.
//

import SwiftUI

@main
struct LocalizationApp: App {
    @StateObject private var settings = AppSettings()
    var body: some Scene {
        WindowGroup {
            CatalogListView()
                .environmentObject(settings)
        }
    }
}

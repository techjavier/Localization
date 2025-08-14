import SwiftUI

// MARK: - Data Models

enum DemoType: String {
    case plain, plural, region, placeholder
    var label: String { rawValue.capitalized }
}

struct DemoPlural: Hashable {
    var zero: String?
    var one: String?
    var other: String
}

struct DemoRegion: Hashable {
    var base: String
    var us: String?
    var gb: String?
    var idn: String?
    var es: String?
    func value(for code: String) -> String {
        switch code {
        case "US": return us ?? base
        case "GB": return gb ?? base
        case "ID": return idn ?? base
        case "ES": return es ?? base
        default: return base
        }
    }
}

struct DemoItem: Identifiable, Hashable {
    let id = UUID()
    let keyId: String
    let type: DemoType
    let title: String
    let subtitle: String
    let base: String
    let plural: DemoPlural?
    let region: DemoRegion?
    let placeholders: [String]
}

// MARK: - Seed

let demoItems: [DemoItem] = [
    DemoItem(keyId: "greeting.simple", type: .plain, title: "Hello", subtitle: "Basic greeting", base: "Hello!", plural: nil, region: nil, placeholders: []),
    DemoItem(keyId: "farewell.simple", type: .plain, title: "Goodbye", subtitle: "Friendly farewell", base: "Goodbye.", plural: nil, region: nil, placeholders: []),
    DemoItem(keyId: "cta.continue", type: .plain, title: "Continue", subtitle: "Call to action", base: "Tap to continue", plural: nil, region: nil, placeholders: []),
    DemoItem(keyId: "sentence.long", type: .plain, title: "Long Sentence", subtitle: "Long descriptive text", base: "This is a long sentence meant to show wrapping and layout.", plural: nil, region: nil, placeholders: []),
    DemoItem(keyId: "welcome.back", type: .plain, title: "Welcome Back", subtitle: "Return greeting", base: "Welcome back, friend.", plural: nil, region: nil, placeholders: []),
    DemoItem(keyId: "cart.items", type: .plural, title: "Cart Items", subtitle: "Items in cart", base: "You have %d items in your cart.", plural: DemoPlural(zero: "Your cart is empty.", one: "You have 1 item in your cart.", other: "You have %d items in your cart."), region: nil, placeholders: ["%d"]),
    DemoItem(keyId: "notifications.count", type: .plural, title: "Notifications", subtitle: "Number of alerts", base: "You have %d notifications.", plural: DemoPlural(zero: "No notifications.", one: "1 notification.", other: "You have %d notifications."), region: nil, placeholders: ["%d"]),
    DemoItem(keyId: "messages.new", type: .plural, title: "New Messages", subtitle: "Inbox updates", base: "You have %d new messages.", plural: DemoPlural(zero: "No new messages.", one: "1 new message.", other: "You have %d new messages."), region: nil, placeholders: ["%d"]),
    DemoItem(keyId: "color.word", type: .region, title: "Color", subtitle: "American vs British spelling", base: "Color", plural: nil, region: DemoRegion(base: "Color", us: "Color", gb: "Colour", idn: nil, es: nil), placeholders: []),
    DemoItem(keyId: "postal.code", type: .region, title: "ZIP Code", subtitle: "US vs others", base: "ZIP Code", plural: nil, region: DemoRegion(base: "ZIP Code", us: "ZIP Code", gb: "Postcode", idn: "Postal Code", es: nil), placeholders: []),
    DemoItem(keyId: "downloads.count", type: .placeholder, title: "Downloads", subtitle: "Uses %lld", base: "%lld downloads", plural: nil, region: nil, placeholders: ["%lld"]),
    DemoItem(keyId: "files.count", type: .placeholder, title: "Files", subtitle: "Uses %d", base: "%d files", plural: nil, region: nil, placeholders: ["%d"])
]

// MARK: - Settings

class AppSettings: ObservableObject {
    @Published var locale = "en"
    @Published var region = "US"
    @Published var count = 1
    @Published var pseudolocalize = false
    @Published var rtl = false
}

// MARK: - Helpers

func pseudolocalize(_ text: String) -> String {
    let map: [Character: Character] = ["a":"á","e":"é","i":"í","o":"ó","u":"ú","A":"Á","E":"É","I":"Í","O":"Ó","U":"Ú"]
    return "⟦" + String(text.map { map[$0] ?? $0 }) + "⟧"
}

func resolvedText(for item: DemoItem, settings: AppSettings) -> String {
    var text = item.base
    switch item.type {
    case .plain, .placeholder:
        text = item.base
    case .region:
        if let region = item.region {
            text = region.value(for: settings.region)
        }
    case .plural:
        if let p = item.plural {
            if settings.count == 0, let z = p.zero {
                text = z
            } else if settings.count == 1, let o = p.one {
                text = o
            } else {
                text = p.other.replacingOccurrences(of: "%d", with: "\(settings.count)")
            }
        }
    }
    for ph in item.placeholders {
        switch ph {
        case "%d":
            text = text.replacingOccurrences(of: "%d", with: "5")
        case "%lld":
            text = text.replacingOccurrences(of: "%lld", with: "123456")
        default: break
        }
    }
    if settings.pseudolocalize {
        text = pseudolocalize(text)
    }
    return text
}

// MARK: - Views

struct CatalogListView: View {
    @EnvironmentObject var settings: AppSettings
    @State private var query = ""
    @State private var showSettings = false
    var filtered: [DemoItem] {
        if query.isEmpty { return demoItems }
        return demoItems.filter { $0.title.localizedCaseInsensitiveContains(query) || $0.subtitle.localizedCaseInsensitiveContains(query) }
    }
    var body: some View {
        NavigationStack {
            List(filtered) { item in
                NavigationLink(value: item) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.title)
                            Spacer()
                            Text(item.type.label)
                                .font(.caption2)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.secondary.opacity(0.2)))
                        }
                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationDestination(for: DemoItem.self) { item in
                ItemDetailView(item: item)
            }
            .navigationTitle("Catalog")
            .searchable(text: $query)
            .toolbar {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsSheet()
                    .environmentObject(settings)
            }
        }
    }
}

struct ItemDetailView: View {
    @EnvironmentObject var settings: AppSettings
    let item: DemoItem
    var resolved: String { resolvedText(for: item, settings: settings) }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                controls
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.largeTitle)
                    Text(resolved)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.1)))
                .environment(\.layoutDirection, settings.rtl ? .rightToLeft : .leftToRight)
                explain
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    var controls: some View {
        VStack(alignment: .leading) {
            Picker("Locale", selection: $settings.locale) {
                ForEach(["en","id","es","ar"], id: \.self) { Text($0) }
            }
            Picker("Region", selection: $settings.region) {
                ForEach(["US","GB","ID","ES"], id: \.self) { Text($0) }
            }
            Stepper("Plural sample: \(settings.count)", value: $settings.count, in: 0...200)
            Toggle("Pseudolocalize", isOn: $settings.pseudolocalize)
            Toggle("RTL Preview", isOn: $settings.rtl)
        }
    }
    var explain: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Key: \(item.keyId)")
            Text("Type: \(item.type.label)")
            Text("Placeholders: \(item.placeholders.isEmpty ? "–" : item.placeholders.joined(separator: ", "))")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.1)))
    }
}

struct SettingsSheet: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) private var dismiss
    var sample: String {
        let base = "Sample text"
        return settings.pseudolocalize ? pseudolocalize(base) : base
    }
    var body: some View {
        NavigationStack {
            Form {
                Picker("Locale", selection: $settings.locale) {
                    ForEach(["en","id","es","ar"], id: \.self) { Text($0) }
                }
                Picker("Region", selection: $settings.region) {
                    ForEach(["US","GB","ID","ES"], id: \.self) { Text($0) }
                }
                Stepper("Plural sample: \(settings.count)", value: $settings.count, in: 0...200)
                Toggle("Pseudolocalize", isOn: $settings.pseudolocalize)
                Toggle("RTL Preview", isOn: $settings.rtl)
                Text(sample)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.1)))
                    .environment(\.layoutDirection, settings.rtl ? .rightToLeft : .leftToRight)
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CatalogListView()
        .environmentObject(AppSettings())
}

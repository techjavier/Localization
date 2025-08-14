import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}

struct TagBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(4)
            .background(Capsule().fill(Color.accentColor.opacity(0.2)))
    }
}

struct Card<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Style.cornerRadius)
                    .fill(Color(.secondarySystemBackground))
            )
            .shadow(radius: 1)
    }
}

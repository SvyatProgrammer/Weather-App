import SwiftUI

struct WeatherCard<Content: View>: View {

    let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(.background.opacity(0.75))
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .shadow(
                color: .black.opacity(0.08),
                radius: 10,
                y: 5
            )
    }
}

import SwiftUI

struct WeatherInfoView: View {
    
    let icon : String
    let title : String
    let value : String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    WeatherInfoView(icon: "wind", title: "Wind", value: "30")
}

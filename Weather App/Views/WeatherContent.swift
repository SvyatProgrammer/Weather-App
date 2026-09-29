import SwiftUI

struct WeatherContent: View {
    
    let weather : WeatherResponse
    let city : String
    
    private var condition : WeatherCondition {
        WeatherCondition.from(code: weather.current.weatherCode)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(city)
                .font(.largeTitle)
                .fontWeight(.bold)
            Image(systemName: condition.icon)
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
            Text("\(Int(weather.current.temperature2m))°")
                .font(.system(size: 80))
                .fontWeight(.bold)
            Text(condition.title)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                WeatherInfo(icon: "wind", title: "Wind", value: "\(weather.current.windSpeed10m)km/h")
                
                Spacer()
                
                WeatherInfo(icon: "humidity", title: "Humidity", value: "\(weather.current.relativeHumidity2m)%")
            }
            
            Text("5-Day Forecast")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(weather.forecastDays) { day in
                        ForecastCard(day: day)
                    }
                }
            }
        }
        .padding()
    }
}

import Foundation

struct WeatherCondition {
    
    let title : String
    let icon : String
    
    static func from(code: Int) -> WeatherCondition {
        switch code {
        case 0:
            return WeatherCondition(title: "Clear", icon: "sun.max.fill")
        case 1, 2, 3:
            return WeatherCondition(title: "Partly Cloudy", icon: "cloud.sun.fill")
        case 45, 48:
            return WeatherCondition(title: "Fog", icon: "cloud.fog.fill")
        case 51, 53, 55, 56, 57:
            return WeatherCondition(title: "Drizzle", icon: "cloud.drizzle.fill")
        case 61, 63, 65, 66, 67:
            return WeatherCondition(title: "Rain", icon: "cloud.rain.fill")
        case 71, 73, 75, 77:
            return WeatherCondition(title: "Snow", icon: "cloud.snow.fill")
        case 80, 81, 82:
            return WeatherCondition(title: "Rain Showers", icon: "cloud.heavyrain.fill")
        case 95, 96, 99:
            return WeatherCondition(title: "Thunderstorm", icon: "cloud.bolt.rain.fill")
        default:
            return WeatherCondition(title: "Unknown", icon: "questionmark")
        }
        
    }
}

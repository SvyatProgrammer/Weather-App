import Foundation

struct WeatherResponse : Codable {
    let current : CurrentWeather
    let daily : DailyWeather
    
    var forecastDays : [ForecastDay] {
        daily.time.indices.map { index in
            ForecastDay(date: daily.time[index], maxTemperature: daily.temperatureMax[index], minTemperature: daily.temperatureMin[index], weatherCode: daily.weatherCode[index])
        }
    }
}

struct CurrentWeather : Codable {
    let temperature2m : Double
    let relativeHumidity2m : Double
    let windSpeed10m : Double
    let weatherCode : Int
    
    enum CodingKeys : String, CodingKey {
        case temperature2m = "temperature_2m"
        case relativeHumidity2m = "relative_humidity_2m"
        case windSpeed10m = "wind_speed_10m"
        case weatherCode = "weather_code"
    }
}

struct DailyWeather : Codable {
    let time : [String]
    let temperatureMax : [Double]
    let temperatureMin : [Double]
    let weatherCode : [Int]
    
    enum CodingKeys : String, CodingKey {
        case time
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case weatherCode = "weather_code"
    }
}

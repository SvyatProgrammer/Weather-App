import Foundation

struct WeatherServices {
    func fetchWeather(latitude : Double, longitude : Double) async throws -> WeatherResponse {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto") else {
            throw WeatherError.invalidResponse
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(WeatherResponse.self, from: data)
    }
    
    func searchCity(name : String) async throws -> LocationResult {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(encodedName)&count=1&language=en&format=json")!
        
        let(data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(LocationResponse.self, from: data)
        
        guard let location = response.results?.first else {
            throw WeatherError.cityNotFound
        }
        
        return location
    }
    
    func searchCities(name: String) async throws -> [LocationResult] {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(encodedName)&count=5&language=en&format=json")!
        
        let(data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(LocationResponse.self, from: data)
        
        return response.results ?? []
    }
}

import Foundation
import Observation

@Observable
final class WeatherViewModel {
    
    var weather : WeatherResponse?
    var isLoading = false
    var errorMessage : String?
    var city = "Brest"
    var searchText = ""
    var suggestions : [LocationResult] = []
    var suggetionTask : Task<Void, Never>?
    
    private let weatherService = WeatherServices()
    
    func loadWeather(for cityName : String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            
            let location = try await weatherService
                .searchCity(name: cityName)
            
            let result = try await weatherService
                .fetchWeather(latitude: location.latitude, longitude: location.longitude)
            
            weather = result
            city = location.name
            searchText = location.name
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadWeather(latitude: Double, longitude: Double, cityName: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await weatherService.fetchWeather(latitude: latitude, longitude: longitude)
            
            weather = result
            city = cityName
            searchText = cityName
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func searchCity() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            return
        }
        
        Task {
            await loadWeather(for: query)
        }
    }
    
    func updateSuggestions() {
        suggetionTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard query.count >= 2 else {
            return
        }
        
        suggetionTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            
            guard !Task.isCancelled else {
                return
            }
            
            do {
                let results = try await weatherService.searchCities(name: query)
                
                guard !Task.isCancelled else {
                    return
                }
                
                suggestions = results
            } catch {
                suggestions = []
            }
        }
    }
}

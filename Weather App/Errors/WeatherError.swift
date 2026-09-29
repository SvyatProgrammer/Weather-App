import Foundation

enum WeatherError : LocalizedError {
    case cityNotFound
    
    var errorDescription : String? {
        switch self {
        case .cityNotFound :
            return "City not found."
        }
    }
}

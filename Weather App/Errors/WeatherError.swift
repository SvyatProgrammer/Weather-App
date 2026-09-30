import Foundation

enum WeatherError : LocalizedError {
    case cityNotFound
    case locationDenied
    case invalidResponse
    
    var errorDescription : String? {
        switch self {
        case .cityNotFound:
            return "City not found."
        case .locationDenied:
            return "Location access wa denied."
        case .invalidResponse:
            return "the server returned invalid data."
        }
    }
}

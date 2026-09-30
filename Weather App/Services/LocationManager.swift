import Foundation
import CoreLocation

final class LocationManager : NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var continuation : CheckedContinuation<CLLocation, Error>?
    private var authorizationContinuation:
        CheckedContinuation<Void, Error>?
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocation() async throws -> CLLocation {
        try await requestAuthorization()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager : CLLocationManager, didUpdateLocations locations : [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        continuation?.resume(returning: location)
        
        continuation = nil
    }
    
    func locationManager(_ manager : CLLocationManager, didFailWithError error : Error) {
        continuation?.resume(throwing: error)
        
        continuation = nil
    }
    
    func cityName(from location : CLLocation) async throws -> String {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first else {
            throw WeatherError.cityNotFound
        }
        
        return placemark.locality ?? placemark.subAdministrativeArea ?? "Unknown"
    }
    
    func loactionManager(_ manager : CLLocationManager, didChangeAuthorization status : CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationContinuation?.resume()
        case .denied, .restricted:
            authorizationContinuation?.resume(throwing: WeatherError.locationDenied)
        default:
            break
        }
        
        authorizationContinuation = nil
    }
    
    private func requestAuthorization() async throws {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return
        case .denied, .restricted:
            throw WeatherError.locationDenied
        case.notDetermined:
            try await withCheckedThrowingContinuation { continuation in
                self.authorizationContinuation = continuation
                manager.requestWhenInUseAuthorization()
            }
        @unknown default:
            throw WeatherError.locationDenied
        }
    }
}

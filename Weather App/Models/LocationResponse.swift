import Foundation

struct LocationResponse : Codable {
    let results : [LocationResult]?
}

struct LocationResult : Codable, Identifiable {
    let name : String
    let latitude : Double
    let longitude : Double
    let country : String?
    
    var id : String {
        "\(latitude),\(longitude)"
    }
}

import Foundation

struct ForecastDay : Identifiable {
    let date : String
    let maxTemperature : Double
    let minTemperature : Double
    let weatherCode : Int
    
    var id : String {
        date
    }
    
    var displayDate : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: date) else {
            return date
        }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }
        
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: date)
    }
}

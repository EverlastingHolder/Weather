import Foundation

struct ForecastApiModel: Codable, Hashable {
    var cod: String? = nil
    var message: Int? = nil
    var cnt: Int? = nil
    var list: [ListWeather] = []
    var city: City = City()
}

struct ListWeather: Codable, Hashable {
    var dt: Int? = nil
    var main: MainForecast = MainForecast()
    var weather: [Weather]? = []
    var clouds: Clouds? = Clouds()
    var wind: Wind? = Wind()
    var visibility: Int? = nil
    var pop: Double? = nil
    var sys: SysForecast? = SysForecast()
    var dt_txt: String = ""
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd, HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(dt ?? 0)))
    }
}

struct MainForecast: Codable, Hashable {
    var temp: Double = 0
    var feels_like: Double? = nil
    var temp_min: Double? = nil
    var temp_max: Double? = nil
    var pressure: Int? = nil
    var sea_level: Int? = nil
    var grnd_level: Int? = nil
    var humidity: Int? = nil
    var temp_kf: Double? = nil
    
    func celciusOrFarenheit(toggle: Bool) -> String {
        if toggle {
            return String(format: "%.0f", temp)
        } else {
            return String(format: "%.0f", celciusToFarenheit())
        }
    }
    
    private func celciusToFarenheit() -> Double {
        (temp * (9/5) ) + 32
    }
    
}

struct SysForecast: Codable, Hashable {
    var pod: String? = nil
}

struct City: Codable, Hashable {
    var id: Int? = nil
    var name: String = ""
    var coord: Coord? = Coord()
    var country: String? = nil
    var population: Int? = nil
    var timezone: Int? = nil
    var sunrise: Int? = nil
    var sunset: Int? = nil
}

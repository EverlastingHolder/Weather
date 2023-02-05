import Foundation

struct WeatherApiModel: Codable, Hashable, Comparable {
    static func < (lhs: WeatherApiModel, rhs: WeatherApiModel) -> Bool {
        lhs.id ?? 0 < rhs.id ?? 0
    }
    
    var coord: Coord? = nil
    var weather: [Weather]? = []
    var base: String? = nil
    var main: Main? = nil
    var visibility : Int? = nil
    var wind: Wind? = nil
    var clouds: Clouds? = nil
    var dt: Int = 0
    var sys: Sys? = nil
    var timezone: Int? = nil
    var id: Int? = nil
    var name: String? = nil
    var cod: Int? = nil
    
    var date: String {
        Date(timeIntervalSince1970: TimeInterval(dt)).getFormattedDate(format: "dd.MM.yyyy hh:mm:ss")
    }
}

struct Coord: Codable, Hashable {
    var lon: Double? = nil
    var lat: Double? = nil
}

struct Sys: Codable, Hashable {
    var type: Int? = nil
    var id: Int? = nil
    var country: String? = nil
    var sunrise: Int? = nil
    var sunset: Int? = nil
}

struct Clouds: Codable, Hashable {
    var all: Int? = nil
}

struct Wind: Codable, Hashable {
    var speed: Double? = nil
    var deg: Int? = nil
    var gust: Double? = nil
}

struct Main: Codable, Hashable {
    var temp: Double? = nil
    var feelsLike: Double? = nil
    var tempMin: Double? = nil
    var tempMax: Double? = nil
    var pressure: Int? = nil
    var humidity: Int? = nil
    var seaLevel: Int? = nil
    var grndLevel: Int? = nil
    
    func celciusOrFarenheit(toggle: Bool) -> String {
        if toggle {
            return String(format: "%.0f", temp ?? 0)
        } else {
            return String(format: "%.0f", celciusToFarenheit())
        }
    }
    
    private func celciusToFarenheit() -> Double {
        (temp ?? 0 * (9/5) ) + 32
    }
}

struct Weather: Codable, Hashable {
    var id: Int? = nil
    var main: String? = nil
    var description: String? = nil
    var icon: String? = nil
}

import Foundation

struct WeatherApiModel: Codable, Hashable, Comparable {
    static func < (lhs: WeatherApiModel, rhs: WeatherApiModel) -> Bool {
        lhs.id < rhs.id
    }
    
    var coord: Coord? = Coord()
    var weather: [Weather]? = []
    var base: String? = nil
    var main: Main = Main()
    var visibility : Int? = nil
    var wind: Wind? = Wind()
    var clouds: Clouds? = Clouds()
    var dt: Int? = nil
    var sys: Sys? = Sys()
    var timezone: Int? = nil
    var id: Int
    var name: String? = nil
    var cod: Int? = nil
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(dt ?? 0)))
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
    var temp: Double = 0
    var feelsLike: Double? = nil
    var tempMin: Double? = nil
    var tempMax: Double? = nil
    var pressure: Int? = nil
    var humidity: Int? = nil
    var seaLevel: Int? = nil
    var grndLevel: Int? = nil
    
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

struct Weather: Codable, Hashable {
    var id: Int? = nil
    var main: String? = nil
    var description: String? = nil
    var icon: String? = nil
}

import Foundation

struct ForecastApiModel: Codable, Hashable {
    var cod: String? = nil
    var message: Int? = nil
    var cnt: Int? = nil
    var list: [ListWeather]? = []
    var city: City? = City()
}

struct ListWeather: Codable, Hashable {
    var dt: Int? = nil
    var weather: [Weather]? = []
    var clouds: Clouds? = Clouds()
    var wind: Wind? = Wind()
    var visibility: Int? = nil
    var pop: Int? = nil
    var sys: SysForecast? = SysForecast()
    var dt_txt: String? = nil
}

struct MainForecast: Codable, Hashable {
    var temp: Double? = nil
    var feels_like: Double? = nil
    var temp_min: Double? = nil
    var temp_max: Double? = nil
    var pressure: Int? = nil
    var sea_level: Int? = nil
    var grnd_level: Int? = nil
    var humidity: Int? = nil
    var temp_kf: Double? = nil
    
}

struct SysForecast: Codable, Hashable {
    var pod: String? = nil
}

struct City: Codable, Hashable {
    var id: String? = nil
    var name: String? = nil
    var coord: Coord? = Coord()
    var country: String? = nil
    var population: Int? = nil
    var timezone: Int? = nil
    var sunrise: Int? = nil
    var sunset: Int? = nil
}

import Foundation
import Combine

protocol WeatherServiceType {
    func getCurrentCity(
        lat: Double,
        lon: Double
    ) -> AnyPublisher<WeatherApiModel, Error>
    
    func searchCity(
        city: String
    ) -> AnyPublisher<WeatherApiModel, Error>
}

final class WeatherService: WeatherServiceType {
    private let baseNetwork: BaseNetwork = BaseNetwork()
    
    func getCurrentCity(lat: Double, lon: Double) -> AnyPublisher<WeatherApiModel, Error> {
        self.baseNetwork.run(
            params: [
                "lat": lat.description,
                "lon": lon.description
            ]
        )
    }
    
    func searchCity(city: String) -> AnyPublisher<WeatherApiModel, Error> {
        self.baseNetwork.run(
            params: [
                "q": city
            ]
        )
    }
}

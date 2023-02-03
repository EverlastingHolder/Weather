import Foundation
import Combine
import SwiftUI

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
    private let network: BaseNetwork = BaseNetwork()
    
    func getCurrentCity(lat: Double, lon: Double) -> AnyPublisher<WeatherApiModel, Error> {
        self.network.run(
            params: [
                "lat": lat.description,
                "lon": lon.description
            ]
        )
    }
    
    func searchCity(city: String) -> AnyPublisher<WeatherApiModel, Error> {
        self.network.run(
            params: [
                "q": city
            ]
        )
    }
}

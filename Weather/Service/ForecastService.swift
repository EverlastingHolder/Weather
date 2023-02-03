import Foundation
import Combine
import SwiftUI

protocol ForecastServiceType {
    func getWeatherDay(
        lat: Double,
        lon: Double
    ) -> AnyPublisher<ForecastApiModel, Error>
}

final class ForecastService: ForecastServiceType {
    private let baseNetwork: BaseNetwork = BaseNetwork()
    
    func getWeatherDay(lat: Double, lon: Double) -> AnyPublisher<ForecastApiModel, Error> {
        self.baseNetwork.run(
            "forecast",
            params: [
                "lat": lat.description,
                "lon": lon.description
            ]
        )
    }
}

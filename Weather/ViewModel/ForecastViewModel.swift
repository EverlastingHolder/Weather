import Foundation
import Combine

final class ForecastViewModel: ObservableObject {
    private let service: ForecastService = ForecastService()
    
    private var bag: Set<AnyCancellable> = .init()
    
    let lat: Double
    let lon: Double
    
    init(
        lat: Double,
        lon: Double
    ) {
        self.lat = lat
        self.lon = lon
        
        self.service
            .getWeatherDay(lat: lat, lon: lon)
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { c in
                print("result \(c)")
            }) { result in
                print("result: \(result)")
            }
            .store(in: &bag)
    }
    
    deinit {
        bag.forEach { $0.cancel() }
        bag.removeAll()
    }
}

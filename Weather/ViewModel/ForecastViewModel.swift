import Foundation
import Combine

class ForecastViewModel: ObservableObject {
    private let service: ForecastService = ForecastService()
    
    @Published var forecast: ForecastApiModel = .init()
    
    private var bag: Set<AnyCancellable> = .init()
    
    func getWeatherDay(lat: Double, lon: Double) {
        self.service
            .getWeatherDay(lat: lat, lon: lon)
            .subscribe(on: Scheduler.main)
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { _ in }) { result in
                self.forecast = result
            }
            .store(in: &bag)
    }
    
    deinit {
        bag.forEach { $0.cancel() }
        bag.removeAll()
    }
}

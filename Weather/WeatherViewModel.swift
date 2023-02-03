import Foundation
import Combine
import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    private let weatherService: WeatherService = WeatherService()
    
    @Published var search: String = ""
    @Published var selectedItem: WeatherApiModel? = nil
    @Published var weather: [WeatherApiModel] = []
    @Published var toggle: Bool = false
    @Published var lastLocation: CLLocation = .init()
    
    private let manager: CLLocationManager = CLLocationManager()
    private var bag: Set<AnyCancellable> = .init()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        self.$selectedItem
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink { item in
                withAnimation() {
                    self.moveToTop()
                }
            }
            .store(in: &bag)
        
        self.$search
            .debounce(for: .milliseconds(500), scheduler: Scheduler.main)
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.background)
            .sink { result in
                self.fetchCity(city: result)
            }
            .store(in: &bag)
    }
    
    private func fetchCity(city: String) {
        self.weatherService
            .searchCity(city: city)
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { _ in }) { [self] result in
                withAnimation {
                    weather.append(result)
                    weather = removeDuplicateElements(weathers: weather)
                }
            }
            .store(in: &bag)
    }
    
    func requestCurrentLocation() {
        self.weatherService
            .getCurrentCity(
                lat: lastLocation.coordinate.latitude,
                lon: lastLocation.coordinate.longitude
            )
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .sink(receiveCompletion: { _ in }) { [self] result in
                withAnimation {
                    if selectedItem?.id != result.id {
                        weather.append(result)
                        weather = removeDuplicateElements(weathers: weather)
                        selectedItem = result
                    }
                }
            }
            .store(in: &bag)
    }
    
    private func removeDuplicateElements(weathers: [WeatherApiModel]) -> [WeatherApiModel] {
        var unique = [WeatherApiModel]()
        for weather in weathers {
            if !unique.contains(where: { $0.id == weather.id }) {
                withAnimation {
                    unique.append(weather)
                }
            }
        }
        return unique
    }
    
    func moveToTop() {
        if let item = selectedItem {
            weather = weather.filter( { $0.id != item.id } )
            weather.insert(item, at: 0)
        }
    }
    
    deinit {
        bag.forEach { $0.cancel() }
        bag.removeAll()
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
    }
}

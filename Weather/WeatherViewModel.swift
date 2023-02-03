import Foundation
import Combine
import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    private let weatherService: WeatherService = WeatherService()
    
    @Published var search: String = ""
//    @Published var selectedItem: [Dictionary<Int, WeatherApiModel>.Element] = []
//    @Published var selectedItem: [Int: WeatherApiModel] = [:]

    @Published var selectedItem: WeatherApiModel?
    @Published var weatherApi: [Dictionary<Int, WeatherApiModel>.Element] = []
    private var weather: [Int: WeatherApiModel] = [:]
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
        
        self.$search
            .debounce(for: .milliseconds(500), scheduler: Scheduler.main)
            .subscribe(on: Scheduler.main)
            .receive(on: Scheduler.main)
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
            .sink(receiveCompletion: { _ in }) { result in
//                self.weatherApi.append(result)
//                self.weatherApi.append((key: result.id, value: result))
                withAnimation {
                    self.weather[result.id] = result
                    self.weatherApi = self.weather.sorted(by: <)
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
            .sink(receiveCompletion: { _ in }) { result in
//                self.weatherApi.append(result)
//                self.weatherApi = self.removeDuplicateElements(weathers: self.weatherApi)
                withAnimation {
                self.weather[result.id] = result
                self.weatherApi = self.weather.sorted(by: <)
                
//                    self.selectedItem.removeAll()
//                    self.selectedItem.append((key: result.id, value: result))
                    self.selectedItem = result
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
